From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Mon, 7 May 2007 13:36:55 -0500
Message-ID: <20070507133655.4cbc1252@gara>
References: <20070503140804.463b20e1@naruto>
	<463B4A1B.4070201@bull.net>
	<20070507111952.7868bc1c@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56736 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbXEGSg7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 14:36:59 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l47IbpOw012366
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 14:37:51 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47Iasv3559460
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 14:36:54 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47IarSh029993
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 14:36:54 -0400
In-Reply-To: <20070507111952.7868bc1c@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 7 May 2007 11:19:52 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:
> I tried the patches and while the tools such as mkfs and debugfs seem
> to work fine, I am still unable to mount a filesystem with block
> numbers exceeding 32 bits.

Correction,

I tested debugfs on a 32bit blocks filesystem.  Both debugfs and fsck
failed when attempting to use a 64bit filesystem.

-JRS
