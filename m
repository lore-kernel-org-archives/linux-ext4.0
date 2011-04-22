From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Quick EXT4 discard question
Date: Fri, 22 Apr 2011 15:59:44 -0400
Message-ID: <BANLkTikW+E14XdObMALKejEWCrxnbKn=8g@mail.gmail.com>
References: <1303433101.1389.132.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54588 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab1DVUAF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Apr 2011 16:00:05 -0400
Received: by bwz15 with SMTP id 15so600515bwz.19
        for <linux-ext4@vger.kernel.org>; Fri, 22 Apr 2011 13:00:04 -0700 (PDT)
In-Reply-To: <1303433101.1389.132.camel@keith-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 21, 2011 at 8:45 PM, Keith Mannthey <kmannth@us.ibm.com> wrote:
<snip>
> I am new to SSDs and discard is there something else I need to do to
> make these drives work as expected?

Keith,

If you're new to SSD trim, you might want to read this SUSE wiki page.

http://en.opensuse.org/SDB:SSD_discard_%28trim%29_support

(I wrote most of it, but I tried to keep it factual.)

For reference, it talks some about opensuse 11.2 and 11.3 but you can
just think of those as older kernels.  (11.4 just came out and has a
2.6.37 kernel.)

Greg
