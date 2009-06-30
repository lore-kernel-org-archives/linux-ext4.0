From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: [PATCH] debugfs: don't try to fclose NULL
Date: Tue, 30 Jun 2009 17:44:55 +0200
Message-ID: <m2r5x1pvyg.fsf@vador.mandriva.com>
References: <4A451A23.20307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:53639 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752809AbZF3PoX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jun 2009 11:44:23 -0400
In-Reply-To: <4A451A23.20307@redhat.com> (Eric Sandeen's message of "Fri, 26
	Jun 2009 13:57:39 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> do_logdump may jump to errout if fopen(out_file) fails, 
> but in that case out_file is NULL, and fclose will segfault.

You should report that segfault to glibc authors too.
