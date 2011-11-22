From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH v2] jbd: clear revoked flag on buffers before a new transaction started
Date: Tue, 22 Nov 2011 07:52:01 -0500
Message-ID: <83C2C779-F8A4-43D1-87B4-B04844FAA088@mit.edu>
References: <1321695269-3319-1-git-send-email-xiaoqiangnk@gmail.com> <20111122002326.GH4017@quack.suse.cz> <CAGBYx2YjzYSXXnTCej_YzdJ+2q9cMTOG24bso7FHB4ZJwa_Ttw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:44524 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab1KVMwA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Nov 2011 07:52:00 -0500
In-Reply-To: <CAGBYx2YjzYSXXnTCej_YzdJ+2q9cMTOG24bso7FHB4ZJwa_Ttw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 21, 2011, at 8:55 PM, Yongqiang Yang wrote:
> YES!  I had sent out the patch for jbd2.  It seems that Ted is busy these days.

I generally start integrating patches for the next merge window after -rc3.

I've currently been more focused on the 1.42 e2fsprogs release.

-- Ted

