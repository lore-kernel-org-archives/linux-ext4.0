From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] delayed allocation, mballoc, etc
Date: Thu, 07 Dec 2006 20:26:09 +0300
Message-ID: <m3fybrfwi6.fsf@bzzz.home.net>
References: <m3irgwv59d.fsf@bzzz.home.net> <45784CD6.3090501@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:54889 "EHLO gw.home.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162561AbWLGR0Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Dec 2006 12:26:24 -0500
To: Valerie Clement <valerie.clement@bull.net>
In-Reply-To: <45784CD6.3090501@bull.net> (Valerie Clement's message of "Thu\,
	07 Dec 2006 18\:18\:14 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Valerie Clement (VC) writes:

 VC> Alex Tomas wrote:
 >> Good day,
 >> 
 >> I'd like to ask the community to discuss and review few things
 >> I've been working on. we propose set of patches with intention
 >> to improve performance of ext4:
 >> 
 >> * mballoc v4
 >> 
 VC> Hi Alex,
 VC> I retrieved the patches from your site and began to have a look at them.
 VC> I found some issues in the ext4-mballoc patch concerning the 48bit
 VC> physical block number support.
 VC> The patch in attachment fixes the problem, if I'm not wrong.
 VC> Regards,

thanks for the patch, Valerie!


to be honest, I haven't implemented 48bit support in mballoc yet.
that would be a next step.

thanks, Alex
