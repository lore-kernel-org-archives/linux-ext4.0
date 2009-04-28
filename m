From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] Convert ext4_lock_group to use sb_bgl_lock
Date: Mon, 27 Apr 2009 23:00:16 -0600
Message-ID: <20090428050016.GL3209@webber.adilger.int>
References: <1240860896-2011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65254 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZD1FAc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 01:00:32 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3S50SmR024660
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2009 22:00:30 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIS00300OFOZU00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 27 Apr 2009 22:00:28 -0700 (PDT)
In-reply-to: <1240860896-2011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 28, 2009  01:04 +0530, Aneesh Kumar wrote:
> +static inline spinlock_t *ext4_group_lock(struct super_block *sb, ext4_group_t group)
>  {
> +	return bgl_lock_ptr(EXT4_SB(sb)->s_blockgroup_lock, group);
> +}
>  
> +static inline void ext4_lock_group(struct super_block *sb,ext4_group_t group)
> +{
> +	spin_lock(ext4_group_lock(sb, group));
>  }

I find it a bit confusing to have both ext4_group_lock() and ext4_lock_group()
as it isn't obvious without looking at the functions which one is which.

I'd rather have a function name like "ext4_group_lock_ptr()" or similar,
which is pretty unambiguous.

> -static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
> +static void mb_set_bits(void *bm, int cur, int len)

It also wouldn't be a terrible idea to make the mb_set_bits() function
arguments match the name/order of mb_set_bit():

static inline void mb_set_bit(int bit, void *addr)

static void mb_set_bits(void *bm, int cur, int len)

They should be "bit, addr" and "bit, addr, len", to be more consistent
with ext4_set_bit().  Stuff for a separate patch, however.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

