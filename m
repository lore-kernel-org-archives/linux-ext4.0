From: Andres Freund <andres@anarazel.de>
Subject: Re: EXT4 ENOSPC Bug
Date: Fri, 27 Feb 2009 04:57:01 +0100
Message-ID: <49A7648D.2080705@anarazel.de>
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AF598.7080400@anarazel.de> <499C7B41.1090800@anarazel.de> <20090218212957.GR3600@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	Alex Buell <alex.buell@munted.org.uk>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <jo
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756646AbZB0D51@vger.kernel.org>
In-Reply-To: <20090218212957.GR3600@mini-me.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/18/2009 10:29 PM, Theodore Tso wrote:
>> [10379.575904] ext4: find_group_flex failed, fallback succeeded dir 416319
>> [10379.576002] ext4: find_group_flex failed, fallback succeeded dir 416319
>> [10379.579981] ext4: find_group_flex failed, fallback succeeded dir 416319
>> [10379.580097] ext4: find_group_flex failed, fallback succeeded dir 416319
>> (with different directories)
> Can you send me a dumpe2fs of the filesystem in question?  I'm curious
> what was going on...
Unfortunately the system was rebooted, before I had the chance to do the 
dump - since then the problem has not reemerged.
Would a dump after reboot still be usefull?

Andres
