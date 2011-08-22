From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 01/13] ext4: add a function which extends a group without checking parameters
Date: Sun, 21 Aug 2011 20:51:04 -0600
Message-ID: <A343607D-0D16-4359-98B2-065902277549@dilger.ca>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com> <1313033308-882-2-git-send-email-xiaoqiangnk@gmail.com> <4B3266BE-B083-41DE-BD85-BA1497D9EF51@dilger.ca> <CAGBYx2b3fCkReC4hy-K7jO35oM3thUHO9ST8xEkhVtkZSAqzgQ@mail.gmail.com> <20110821170744.GA19498@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <adilger@s0106002191d9348c.cg.shawcable.net>,
	linux-ext4List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:23657 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1HVCu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Aug 2011 22:50:29 -0400
In-Reply-To: <20110821170744.GA19498@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-21, at 11:07 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 11, 2011 at 02:27:41PM +0800, Yongqiang Yang wrote:
>> YES!  This needs some feedbacks, I thought the old resize interface
>> will be removed after the new resize interface goes into upstream.  So
>> I did not touch
>> old interface.  If we will remain the old interface, I can make some
>> patches which let old resize use common code instead.
> 
> Yes, the backwards compatibility requirements for the kernel means
> that we have to keep the old ioctl's working for at least 2-3 years...

I'd be happy with just wiring up the old ioctls to the new code, and having the kernel ignore the passed parameters and just do it's own thing to resize to the end of the group.

Cheers, Andreas