From: "Peter Meier" <meiepeter@gmail.com>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Mon, 28 Jul 2008 15:11:07 +0000
Message-ID: <c354edc90807280811l57c39321lc7e6abeab2a82eb1@mail.gmail.com>
References: <c354edc90807270328gb835f39g530dc8173e7284f8@mail.gmail.com>
	 <20080727202302.GA7922@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.235]:1078 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbYG1PLK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 11:11:10 -0400
Received: by qb-out-0506.google.com with SMTP id a16so532187qbd.17
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 08:11:08 -0700 (PDT)
In-Reply-To: <20080727202302.GA7922@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Well, my installation went fine using "nodelalloc" with ext4-3,
but then of course I killed the file system when I forgot to add
rootflags=nodelalloc to the kernel's boot command line in the
grub config, so it got mounted with delalloc and proceeded
to eat itself.

I'm stubborn, so I'm going to try again. I'm unsure whether to
try with 2.6.26-ext4-4 and delalloc turned on, however, since
ming's patch was supposed to fix crashes, and I'm not really
looking forward to crashes during installation. So my safest
bet still seems to be to go with nodelalloc.

However, I still don't know whether I can turn delalloc back on
later on the existing FS without missing out on anything from
not having it turned on from the beginning, as per the ques-
tion in my last mail. If anyone could answer that, that'd be
much appreciated.


Greetings,
Peter
