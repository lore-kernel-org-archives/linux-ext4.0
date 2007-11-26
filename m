From: Vincenzo Ciancia <vincenzo_ml@yahoo.it>
Subject: Re: User permissions or UID/GIDs for portable disks?
Date: Mon, 26 Nov 2007 16:56:40 +0100
Message-ID: <fieqbo$pd3$1@ger.gmane.org>
References: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com> <ficqd1$c1b$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33593 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXKZQEy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2007 11:04:54 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IwgMb-0003J8-9f
	for linux-ext4@vger.kernel.org; Mon, 26 Nov 2007 15:59:13 +0000
Received: from dhcp-131-114-3-101.di.unipi.it ([131.114.3.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2007 15:59:13 +0000
Received: from vincenzo_ml by dhcp-131-114-3-101.di.unipi.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2007 15:59:13 +0000
In-Reply-To: <ficqd1$c1b$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> The function has to be non-surjective because uids which differ on the

s/non-surjective/injective/ , i.e. it should not fuse different identities.

Sorry for double posting, will re-read e-mails before sending, in the
future :)

Vincenzo
