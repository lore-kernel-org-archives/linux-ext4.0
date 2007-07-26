From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Thu, 26 Jul 2007 14:35:40 +0400
Message-ID: <46A878FC.5040600@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:57380 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663AbXGZL01 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jul 2007 07:26:27 -0400
In-Reply-To: <46A87858.40005@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jeff Garzik wrote:
> Is this based on Christoph's work?
> 
> Christoph, or some other XFS hacker, already did generic delalloc, 
> modeled on the XFS delalloc code.

nope, this one is simple (something I'd prefer for ext4).

thanks, Alex
