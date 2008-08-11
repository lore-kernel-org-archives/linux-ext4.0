From: Eric Sandeen <sandeen@redhat.com>
Subject: tracepoints in ext4 (and/or ext3?)
Date: Mon, 11 Aug 2008 15:18:07 -0500
Message-ID: <48A09E7F.7060605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbYHKUSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:09 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m7BKI9EI015656
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 16:18:09 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7BKI9MM028804
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 16:18:09 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m7BKI8a6031427
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 16:18:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As just an initial inquiry, I'm wondering how people would feel about
putting some tracepoints (trace_mark()) into ext[34] for monitoring the
fs behavior.

Good/bad/indifferent?

Thanks,

-Eric
