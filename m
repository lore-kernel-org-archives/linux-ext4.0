From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sat, 28 Jul 2007 23:56:14 +0400
Message-ID: <46AB9F5E.8080703@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <20070728195114.GA5952@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:50904 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbXG1T4k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jul 2007 15:56:40 -0400
In-Reply-To: <20070728195114.GA5952@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig wrote:
> This is not based on my attempt to make the xfs writeout path generic.
> Alex's variant is a lot simpler and thus missed various bits required
> for high sustained writeout performance or xfs functionality.

I'd very appreciate any details about high writeout performance.

> That doesn't mean I want to arge against Alex's code although I'd of
> course be more happy if we could actually shared code between multiple
> filesystems.

I'm not against at all, of course. but xfs writeout code looks .. hmm ..
very xfs :)

thanks, Alex
