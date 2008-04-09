From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: e2fsprogs - Unable to run "make check" on ubuntu
Date: Thu, 10 Apr 2008 00:09:18 +0530
Message-ID: <ea11fea30804091139x54b53d6al352a61e7a996bf80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:43858 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbYDISjV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 14:39:21 -0400
Received: by ug-out-1314.google.com with SMTP id z38so1086033ugc.16
        for <linux-ext4@vger.kernel.org>; Wed, 09 Apr 2008 11:39:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was running "make check" on ubuntu 7.10 and encountered the below error

/home/mkatiyar/e2fs-git/lib/ss> make check
        RUN TEST test_ss
/bin/sh: Syntax error: Bad fd number
make: *** [check] Error 2

It is because on ubuntu /bin/sh is a soft link to "dash" on ubuntu
which doesn't seem to respect the standard redirection of >& to
test_out. Changing either the shell to "/bin/bash" or changing the
standard ">& test_out" to ">test_out 2>&1" works properly.

Let me know if we need to change and which one is the correct fix for
it. I will submit a patch for it.

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
