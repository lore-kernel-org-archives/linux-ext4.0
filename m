From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Fix section conflict of ext4_ext_{find_goal,invalidate_cache}
Date: Tue, 15 May 2007 23:06:56 +0400
Message-ID: <464A04D0.80304@clusterfs.com>
References: <20070515171527.GA20407@deprecation.cyrius.com>	 <1179252599.2836.127.camel@dyn9047017100.beaverton.ibm.com> <1179255549.4819.7.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@gmail.com>,
	Martin Michlmayr <tbm@cyrius.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:58416 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbXEOTIq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 May 2007 15:08:46 -0400
In-Reply-To: <1179255549.4819.7.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao wrote:
> Don't know. They should all used by ext4 only. Alex, can we remove these
> exported symbols?

yes, I think so.

thanks, Alex
