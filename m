From: "Eric L" <e.codemonkey@gmail.com>
Subject: [PATCH 0/1] lseek - SEEK_HOLE/SEEK_DATA support
Date: Mon, 16 Oct 2006 20:29:35 -0500
Message-ID: <946a3fda0610161829q55a30fc2i9aca871085241ff7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.224]:64992 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1030215AbWJQB3f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Oct 2006 21:29:35 -0400
Received: by wx-out-0506.google.com with SMTP id h28so2074017wxd
        for <linux-ext4@vger.kernel.org>; Mon, 16 Oct 2006 18:29:35 -0700 (PDT)
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

This small patch set implements the SEEK_HOLE/SEEK_DATA options to the
lseek system call described in Jeff Bonwick's weblog -
http://blogs.sun.com/bonwick/entry/seek_hole_and_seek_data  The first
patch is a small change to the core VFS layer to pass through the
options.  The second implements the actual functionality in ext3.

Signed-off-by: Eric Lorimer <e.codemonkey@gmail.com>
