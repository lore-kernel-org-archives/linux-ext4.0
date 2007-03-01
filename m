From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 14:05:36 -0800
Message-ID: <45E74E30.8080909@goop.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>	<20070225022326.137b4875.akpm@linux-foundation.org>	<20070301183445.GA7911@amitarora.in.ibm.com>	<45E74238.3040606@goop.org> <20070301225855.24ecaba0@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Alan <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:40396 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030377AbXCAWFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2007 17:05:39 -0500
In-Reply-To: <20070301225855.24ecaba0@lxorguk.ukuu.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alan wrote:
> A lot of people get confused about -ENOTTY, but it is the return for
> attempting to use an ioctl on the wrong type of object, so this appears
> to be quite correct.

This is a syscall though; ENOSYS is probably a better match.

    J
