import React from 'react'
import './ExploreMenu.css'
import { menu_list } from '../../assets/assets'

const ExploreMenu = ({ category, setCategory }) => {
	return (
		<div className='explore-menu' id='explore-menu'>
			<h1>Explore our menu</h1>
			<p className='explore-menu-text'>The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.</p>
			<div className="explore-menu-list">
				{menu_list.map((item, index) => {
					return (
						<div onClick={() => setCategory(prev => prev === item.menu_name ? "All" : item.menu_name)} key={index} className='explore-menu-list-item'>
							<img className={category === item.menu_name ? "active" : ""} src={item.menu_image} alt="" />
							<p>{item.menu_name}</p>
						</div>
					)
				})}
			</div>
			<hr />
		</div>
	)
}

export default ExploreMenu