From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Difference in jbd2 behavior between CentOS and Ubuntu while
 unmounting
Date: Tue, 17 May 2016 23:18:34 -0700
Message-ID: <20160518061834.GA4502@birch.djwong.org>
References: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
 <32a9cbf4-4e2d-335c-0603-9639b30e2863@redhat.com>
 <CAN0j2-cp1odcT44ZoeFDGHMF519F2b9Ffa5vc8PJyJfSLcj5-Q@mail.gmail.com>
 <782fe069-c14f-4bae-609e-bbad554cb657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kamran Khan <krkhan@inspirated.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51998 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcERGSl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2016 02:18:41 -0400
Content-Disposition: inline
In-Reply-To: <782fe069-c14f-4bae-609e-bbad554cb657@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2016 at 09:41:07PM -0500, Eric Sandeen wrote:
> On 5/17/16 9:35 PM, Kamran Khan wrote:
> > Yup, the kernel versions are drastically different. It's 3.10 vs 4.2.
> > 
> > The problem on 3.10 though is, while jbd2 holds on to the unmounted
> > device I cannot even rmmod jbd2 or ext4 *even if no other ext
> > filesystems are mounted*. That lock makes it all but impossible to do
> > anything with the block device.
> 
> You may as well try Centos7.2, at least, there are 50+ updates to
> jbd2 & ext4 since 7.1.  If it still persists we can dig further.

Just to throw some gasoline on this fire, I hit the same set of symptoms
a couple of weeks ago while trying to umount /home on 4.5.0 + Ubuntu 16.04.
Ted mused that it could be some process running in a funny mount namespace.
Or systemd dragons.  Or something.

<shrug> I rebooted and haven't seen it since, tho...

--D

> 
> -Eric
> 
> > On Tue, May 17, 2016 at 7:17 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> >> On 5/17/16 7:46 PM, Kamran Khan wrote:
> >>> I'm trying to understand the difference in jbd2 behavior across Ubuntu
> >>> 14.04 and Centos 7.1. Will appreciate any help.
> >>
> >> For starters, what kernel versions are those?  (I know what centos
> >> is, "3.10.0" with updates, which I can check out, but I have no idea
> >> what might be in the Ubuntu distro)
> >>
> >> -Eric
> > 
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
