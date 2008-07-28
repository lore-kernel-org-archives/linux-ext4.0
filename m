From: "Vineet Agarwal" <checkout.vineet@gmail.com>
Subject: Re: merging of two file system
Date: Tue, 29 Jul 2008 00:41:25 +0530
Message-ID: <425904320807281211y517f8847rc93cfa6a3a13aac3@mail.gmail.com>
References: <425904320807270905k32264faaq5c813b73000ee5c6@mail.gmail.com>
	 <20080727225246.GD7922@mit.edu>
	 <5feb302e0807281147y7362a227kb7d37d713be05296@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	listar@nl.linux.org
To: "rishi agrawal" <postrishi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:12752 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYG1TL0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 15:11:26 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1560094nfc.21
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 12:11:25 -0700 (PDT)
In-Reply-To: <5feb302e0807281147y7362a227kb7d37d713be05296@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

yeah i meant that we have to separate filesystems,
stored for example on /dev/hda1 and /dev/hda2, and we want to combine
the data in the two filesystems into a single filesystem /dev/hda3, or
combining the contents of /dev/hda2 so that it is also in /dev/hda1

so is there any mechanism exist to do so either online or offline . please help
thank you
