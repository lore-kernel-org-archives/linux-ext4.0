From: TR Reardon <thomas_reardon@hotmail.com>
Subject: possible different donor file naming in e4defrag
Date: Fri, 15 Aug 2014 16:12:40 -0400
Message-ID: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu004-omc1s26.hotmail.com ([65.55.116.37]:54435 "EHLO
	BLU004-OMC1S26.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbaHOUNX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Aug 2014 16:13:23 -0400
Received: by mail-yk0-f172.google.com with SMTP id 10so2481630ykt.17
        for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2014 13:13:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, e4defrag creates a donor file _in the same directory_ of
the file being defrag'ed.

The problem with this is that the containing directory times are
changed because of the transient presence of the donor file.  Any
thoughts as to moving the donor to a better location, mount-root, or
/lost+found?  Or, ugh, a configurable location, if non-privileged
defrag is important?

+Reardon
