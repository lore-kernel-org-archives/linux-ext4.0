Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52356 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbeLADJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 22:09:34 -0500
Date: Fri, 30 Nov 2018 10:59:45 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 10/12] mke2fs.8: Document fname_encoding options
Message-ID: <20181130155945.GT31885@thunk.org>
References: <20181126221949.12172-1-krisman@collabora.com>
 <20181126221949.12172-11-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126221949.12172-11-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In general, it's better to fold the man page updates with the patch
that adds the support.  So ideally patches 10 and 11 should be folded
into patch 2, and patch 12 should be folded into patch 3.

Thanks,

					- Ted
