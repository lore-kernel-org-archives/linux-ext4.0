From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/13] ext4: add a function which extends a group
 without checking parameters
Date: Sun, 21 Aug 2011 13:07:44 -0400
Message-ID: <20110821170744.GA19498@thunk.org>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
 <1313033308-882-2-git-send-email-xiaoqiangnk@gmail.com>
 <4B3266BE-B083-41DE-BD85-BA1497D9EF51@dilger.ca>
 <CAGBYx2b3fCkReC4hy-K7jO35oM3thUHO9ST8xEkhVtkZSAqzgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@s0106002191d9348c.cg.shawcable.net>,
	linux-ext4 List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33202 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1HURHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Aug 2011 13:07:53 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2b3fCkReC4hy-K7jO35oM3thUHO9ST8xEkhVtkZSAqzgQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 02:27:41PM +0800, Yongqiang Yang wrote:
> YES!  This needs some feedbacks, I thought the old resize interface
> will be removed after the new resize interface goes into upstream.  So
> I did not touch
> old interface.  If we will remain the old interface, I can make some
> patches which let old resize use common code instead.

Yes, the backwards compatibility requirements for the kernel means
that we have to keep the old ioctl's working for at least 2-3 years...

   	   	    			    - Ted

