import { createContext, useEffect, useState } from "react";
// import { food_list } from "../assets/assets";
const apiUrl = import.meta.env.VITE_BACKEND_URL;
// const apiUrl = process.env.BACKEND_URL;


export const StoreContext = createContext(null)

const StoreContextProvider = (props) => {

	const [cartItems, setCartItems] = useState({})
	const [food_list, setFoodList] = useState([]);
	const [isLoading, setIsLoading] = useState(false);
	const [error, setError] = useState(null);

	const addToCart = (itemId) => {
		if (!cartItems[itemId]) {
			setCartItems((prev) => ({ ...prev, [itemId]: 1 }))
		} else {
			setCartItems((prev) => ({ ...prev, [itemId]: prev[itemId] + 1 }))
		}
	}

	const removeFromCart = (itemId) => {
		setCartItems((prev) => ({ ...prev, [itemId]: prev[itemId] - 1 }))
	}

	const getTotalCartAmount = () => {
		let totalAmount = 0;
		for (const item in cartItems) {
			if (cartItems[item] > 0) {
				let itemInfo = food_list.find((product) => product._id === item)
				totalAmount += itemInfo.price * cartItems[item]
			}
		}
		return totalAmount;
	}

	useEffect(() => {
		const fetchFoodList = async () => {
			console.log('VITE_BACKEND_URL =>', import.meta.env.VITE_BACKEND_URL)
			console.log('env =>', import.meta.env.MODE)
			console.log('env Backend =>', import.meta.env.BACKEND_URL)
			setIsLoading(true);
			try {
				// const response = await fetch(`${apiUrl}/api-myfoodShop/food`);
				const response = await fetch('https://backend-6fj4h3coyq-as.a.run.app/api-myfoodShop/food');
				if (!response.ok) {
					throw new Error('Network response was not ok');
				}
				const data = await response.json();
				setFoodList(data.responseData);
			} catch (error) {
				setError(error.message);
			} finally {
				setIsLoading(false);
			}
		};

		fetchFoodList();
	}, []);

	const contextValue = {
		food_list,
		cartItems,
		setCartItems,
		addToCart,
		removeFromCart,
		getTotalCartAmount
	}

	return (
		<StoreContext.Provider value={contextValue}>
			{props.children}
		</StoreContext.Provider>
	)
}

export default StoreContextProvider;