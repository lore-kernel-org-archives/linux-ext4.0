From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 13:04:01 +0300
Message-ID: <m3hcv7f6r2.fsf@bzzz.home.net>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
	<m364bpn5ku.fsf@bzzz.home.net>
	<20070102094727.GA5932@amitarora.in.ibm.com>
	<m3irfobg29.fsf@bzzz.home.net> <459BF0C5.2060302@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:44108 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751098AbXADKEQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jan 2007 05:04:16 -0500
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <459BF0C5.2060302@us.ibm.com> (Mingming Cao's message of "Wed\, 03
	Jan 2007 10\:07\:01 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Mingming Cao (MC) writes:

 MC> But the bug Amit pointed here is unrelated to the code convert
 MC> uninitialized blocks to initialized ones. Rather, it's related to do
 MC> multiple block allocation across on a window with parts already have
 MC> blocks allocated. Without the check, the current code just simply
 MC> allocate the requested extent and insert it into the tree which might
 MC> overlap with existing extent.

correct. thanks for catching. in delayed allocation patch
get_blocks() isn't used and ext4_ext_walk_space() works
right in this case.

thanks, Alex
