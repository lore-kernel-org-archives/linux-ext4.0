From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext2_block_alloc_info
Date: Wed, 24 Dec 2008 10:23:44 -0600
Message-ID: <49526210.4030606@redhat.com>
References: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>	 <804dabb00812201725r304bed36ufc56ebc2393e2299@mail.gmail.com>	 <170fa0d20812221856j4c660384nc2ac693ca8fd0ba4@mail.gmail.com> <804dabb00812222029x76d34c24o798ade5dd0e31351@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@gmail.com>,
	Rohit Sharma <imreckless@gmail.com>,
	Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLXQ0A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Dec 2008 11:26:00 -0500
In-Reply-To: <804dabb00812222029x76d34c24o798ade5dd0e31351@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peter Teoh wrote:
> Sorry, resent due to SMTP error:
> 
> anyone knows any way of enumerating all the low level information like
> these for each file?
> 
> Best I can get is "debugfs":

which uses libext2fs, so if you look at the debugfs source you can find
out which basic library calls to use to get this information.

> So using "show_inode_infor xxxx":
> 
> Inode: 1146884   Type: regular    Mode:  0767   Flags: 0x0
> Generation: 4262211373
> User:     0   Group:     0   Size: 4670783
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 9152
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x46db7fb6 -- Mon Sep  3 11:29:58 2007
> atime: 0x47c66735 -- Thu Feb 28 15:48:05 2008
> mtime: 0x43118298 -- Sun Aug 28 17:23:36 2005
> BLOCKS:
> (0-11):2317946-0, (IND):2317958, (12-1035):2317959-0, (DIND):2318983,
> (IND):2318984, (1036-1140):2318985-0
> TOTAL: 1144
> 
> Here the "BLOCKS" correspond to the block numbering we are talking
> about, right?   It always start at 0 per-file.   "IND" is the indirect
> block.   But what is "DIND"?   "2317946" is the physical block number
> right?   And what is the zero after the "2317946"?

BLOCKS: is the logical/physical mapping for the file.

(AA-BB): YY-ZZ are (logical):physical ranges.

IND is indirect, DIND is double indirect.

As for the "XXXX-0" I'm not sure offhand; it should be the start-end
range for the physical blocks.  Bug perhaps?  :)

-Eric
