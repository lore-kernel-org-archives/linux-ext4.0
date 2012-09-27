From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 05/10] vfs: introduce one hash table
Date: Thu, 27 Sep 2012 13:43:10 +1000
Message-ID: <20120927034310.GM15236@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-6-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56129 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682Ab2I0DnP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 23:43:15 -0400
Content-Disposition: inline
In-Reply-To: <1348404995-14372-6-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 23, 2012 at 08:56:30PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Adds a hash table structure which contains
> a lot of hash list and is used to efficiently
> look up the data temperature of a file or its
> ranges.
>   In each hash list of hash table, the hash node
> will keep track of temperature info.

So, let me see if I've got the relationship straight:

- sb->s_hot_info.hot_inode_tree indexes hot_inode_items, one per inode

- hot_inode_item contains access frequency data for that inode

- hot_inode_item holds a heat hash node to index the access
  frequency data for that inode

- hot_inode_item.hot_range_tree indexes hot_range_items for that inode

- hot_range_item contains access frequency data for that range

- hot_range_item holds a heat hash node to index the access
  frequency data for that range

- sb->s_hot_info.heat_inode_hl indexes per-inode heat hash nodes

- sb->s_hot_info.heat_range_hl indexes per-range heat hash nodes

How about some ascii art? :) Just looking at the hot inode item case
(the range item case is the same pattern, though), we have:


heat_inode_hl		hot_inode_tree
    |			      |
    |			      V
    |		+-------hot_inode_item-------+
+---+		|	frequency data       |
|		V            ^               V
| ...<--hot_inode_item-->... |	  ...<--hot_inode_item-->....
|	frequency data	     |		frequency data
|		^	     |		     ^
|		|	     |		     |
|		|	     |		     |
+------>hot_hash_node-->hot_hash_node-->hot_hash_node-->....


There's no actual data stored in the hot_hash_node, just pointer
back to the frequency data, a hlist_node and a pointer to the
hashlist head. IOWs, I agree with Ram that this does not need to
exist and just embedding a hlist_node inside the hot_inode_item is
all that is needed. i.e:

heat_inode_hl		hot_inode_tree
    |			      |
    |			      V
    |		+-------hot_inode_item-------+
    |		|	frequency data       |
+---+		|	hlist_node           |
|		V            ^ |             V
| ...<--hot_inode_item-->... | |  ...<--hot_inode_item-->....
|	frequency data	     | |	frequency data
+------>hlist_node-----------+ +------->hlist_node--->.....

There's no need for separate allocations, initialisations, locks and
reference counting - all that is already in the hot_inode_item. The
items have the same lifecycle limitations - a hot_hash_node must be
torn down before the frequency data it points to is freed. Finally,
there's no difference in how you move it between lists.

Indeed, calling it a hash is wrong - there's not hashing at all
- it keeping an array of list where each entry corresponds to a
specific temperature. It is a *heat map*, not a hash list. i.e.
inode_heat_map, not heat_inode_hl. HEAT_MAP_SIZE, not HASH_SIZE.

As it is, there aren't any users of the heat maps that are generated
in this patch set - it's not even exported to userspace or to
debugfs, so I'm not sure how it will be used yet. How are these heat
maps going to be used by filesystems, Zhi?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
