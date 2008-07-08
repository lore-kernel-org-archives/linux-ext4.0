From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: error in ext4_mb_release_inode_pa
Date: Mon, 07 Jul 2008 20:04:12 -0500
Message-ID: <4872BD0C.9080404@redhat.com>
References: <48723646.1050101@redhat.com> <20080707232022.GX6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbYGHBEN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2008 21:04:13 -0400
In-Reply-To: <20080707232022.GX6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 07, 2008  10:29 -0500, Eric Sandeen wrote:
>> This was on #linuxfs last night, and I think I've seen at least one
>> other report of it:
>>
>> [22:44]  <shehjart> any ideas why i get the following two lines on the
>> serial console when writing to ext4 over software raid0:
>> [22:44]  <shehjart> pa e00001004112d450: logic 11928, phys. 47003288,
>> len 360
>> [22:45]  <shehjart> EXT4-fs error (device md0):
>> ext4_mb_release_inode_pa: free 176, pa_free 174
> 
> The bug that I recalled from Lustre is unlikely to be the same.  It is
> https://bugzilla.lustre.org/show_bug.cgi?id=15932
> 
> 	"error: N blocks in bitmap, M in gd"
> 
> There was a second bug in ext3_mb_use_best_found() hit on > 8TB filesystems:
> https://bugzilla.lustre.org/show_bug.cgi?id=16101
> 
> 	BUG_ON(ac->ac_b_ex.fe_group != e3b->bd_group);
> 

Thanks Andreas -

In an effort to not lose track of it I filed a bug:

http://bugzilla.kernel.org/show_bug.cgi?id=11053

-Eric
