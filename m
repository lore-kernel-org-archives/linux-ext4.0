From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Wed, 17 Feb 2010 17:36:00 +0900
Message-ID: <4B7BAA70.9070605@jp.fujitsu.com>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com> <20100216185452.GE3153@quack.suse.cz>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39129 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0BQIgJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2010 03:36:09 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o1H8a3m2015998
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 17 Feb 2010 17:36:03 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id E21BA45DE54
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 17:36:02 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id AFA0A45DE53
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 17:36:02 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 8A2D31DB8040
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 17:36:02 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2518D1DB803F
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 17:36:02 +0900 (JST)
In-Reply-To: <20100216185452.GE3153@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Ted and Jan!

tytso@mit.edu wrote:
 > On Tue, Feb 16, 2010 at 04:41:23PM +0900, Toshiyuki Okajima wrote:
 > > >
 > > > jbd2 has new features from jbd. For example, it includes the
 > > > integrity improvement features. The body of ext3 is already enough
 > > > quality. If ext3 changes the journaling interface from jbd into
 > > > jbd2, ext3 filesystem with jbd2 interface may get better integrity
 > > > than with the jbd interface.  (jbd2 is aggressively being developed
 > > > now, so I think we are glad if we can get the effect of the
 > > > development of jbd2 for ext3.)
 > > >
 > > > And ext3 is as de facto standard filesystem, so jbd2 component will
 > > > be used by more people than now if ext3 has the jbd2 interface. If
 > > > many people used the jbd2 interface of ext3, the jbd2 component
 > > > would get more chances to improve the quality and performance and so
 > > > on.
 >
 > Jbd2 is development attention because it is part of ext4.  And you
 > don't get to use the data integrity features of jbd2 without
OK. I understand.
(jbd2 is now developing.)

 > backporting required changes from ext4 to ext3.  At which point, why
 > not have people use ext4?

The reason that I wanted to change the journaling interface into jbd2 were:
- the most of my customers use linux for Mission Critical (M.C.).
- M.C. users want the filesystems which have more integrity for their data.
- I think we should not recommend ext4 to M.C. users because
   for M.C. users, ext4 is still unstable filesystem.
   Therefore I want to let M.C. users use ext3 for the present.
- it is not easy to maintain both jbd and jbd2, so
   I thought it was easy to solve it by unifying the journaling interfaces
   into ext4.

 >
 > Ext4 is format compatible with ext3, and with the proper kernel
 > configuration options, starting with 2.6.33, it's possible to
 > seemlessly allow people who use "mount -t ext3 /dev/sda1 /u1" to have
 > /dev/sda1 mounted using the ext4 file system driver.  So we even have
 > a way that we can seemlessly upgrade existing userspace setups to
 > using ext4 without having to make any system configuration changes
 > (except installing a new kernel, of course).
I know this feature.
But I wanted not to let M.C. users use it now because this feature is
based on ext4.

 >
 > The whole point of creating the ext3/ext4 fork was to not disturb ext3
 > users while ext4 was under development.  This was done by effectively
 > putting ext3 into a bug-fix-only development mode.  Changing ext3 so
 > it could use jbd2 would seem to violate the stability process that we
 > have made to the ext3 users; if people want new features and
 > performance improvements, they can use ext4.

Jan Kara wrote:
 >   Hello,
 >
 > On Tue 16-02-10 16:41:23, Toshiyuki Okajima wrote:
 > > > I will try to change the journaling interface of ext3 from jbd into jbd2.
 > > >
 > > > jbd2 has new features from jbd. For example, it includes the integrity
 > > > improvement features. The body of ext3 is already enough quality. If ext3
 > > > changes the journaling interface from jbd into jbd2, ext3 filesystem with jbd2
 > > > interface may get better integrity than with the jbd interface.
 > > > (jbd2 is aggressively being developed now, so I think we are glad if we can
 > > > get the effect of the development of jbd2 for ext3.)
 > > >
 > > > And ext3 is as de facto standard filesystem, so jbd2 component will be used
 > > > by more people than now if ext3 has the jbd2 interface. If many people used
 > > > the jbd2 interface of ext3, the jbd2 component would get more chances to
 > > > improve the quality and performance and so on.
 > > >
 > > > Besides, ext3 is now the only user of jbd.
 > > > (ocfs2 which was the user of jbd is now the user of jbd2.)
 > > >
 > > > Do you want the jbd2 interface of ext3?
 > > > If you want the jbd2 interface, I will try to implement one.
 >   Yes, as Ted pointed out, the main reason why we have a separate codebase for
 > ext3 and ext4 and similarly jbd and jbd2 is that we didn't want the changes
 > in ext4/jbd2 to influence (and possibly destabilize) ext3 filesystem. So
 > switching ext3 to jbd2 would be directly against this logic...

OK. I see.
(ext3 is already stable filesystem, so, we should not change
  ext3 drastically.)

Thanks,
Toshiyuki Okajima

