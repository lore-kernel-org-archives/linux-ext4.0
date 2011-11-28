From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: WARNING: at fs/inode.c:884 unlock_new_inode+0x34/0x59()
Date: Mon, 28 Nov 2011 13:28:53 -0500
Message-ID: <0F03D476-02D9-4C10-8A4D-7949E5B07CBB@mit.edu>
References: <4ED2994A.9080907@gmail.com> <4ED29C63.8070601@gmail.com> <20111127213432.GA22465@thunk.org> <4ED3CF24.2050702@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Alex <alex.vizor@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:47160 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904Ab1K1S24 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 13:28:56 -0500
In-Reply-To: <4ED3CF24.2050702@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 28, 2011, at 1:12 PM, Alex wrote:

> Hi Ted,
> 
> This is full dmesg with suspend to disk. This time no fs errors happened. And unfortunately I don't remember what kind of errors were there last time.
> 

OK, so you have a very large number of warnings, spanning over several seconds.   That sounds to me like a memory corruption problem, as opposed to some kind of race that only happens for a symlink creation happening right during the suspend/resume.

I can fix the warning and arrange to print more debugging information so that if this happens again, we get more information, but if you can't reproduce it, I'm not sure there's much more I can do for now.

Regards,

-- Ted

