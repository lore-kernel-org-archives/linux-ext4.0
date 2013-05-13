From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: Barriers
Date: Mon, 13 May 2013 07:54:48 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DAE3A619@ATLEXMBX4.ARRS.ARRISI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironmail.arrisi.com ([216.234.147.20]:44387 "EHLO arrisi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232Ab3EMHyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 03:54:51 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm curious if anyone ever tried fua-only jbd? If done with fua's, there
will be no cache flushes at all, thus no occasional spikes. NCQ fua
journalling is potentially more efficient than cache flush.
I know, stale data will be unavoidable (however unlikely) in fua-based
implementation. It is a compromise between ordered,nobarrier (fs
corruption is likely to happen upon power loss) and ordered,barrier (no
fs corruption).
Any advise on what kind of workload to test?

What about having single journal per device as opposed to partition/fs?
What I've found of quick look at jbd2 code, it doesn't seem to be a
problem to set up single journal for several filesystems on the same device.
This will give an advantage of single commit per commit interval as
opposed to several commits per likely to be same interval.

-- 
Regards,
Andrei.

