From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext[234]: cleanup ext[234]_bg_num_gdb()
Date: Tue, 11 Dec 2007 21:41:07 -0800
Message-ID: <20071211214107.4b2fe174.akpm@linux-foundation.org>
References: <20071208153156.GA4878@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
	adilger@clusterfs.com
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbXLLFlo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2007 00:41:44 -0500
In-Reply-To: <20071208153156.GA4878@APFDCB5C>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 9 Dec 2007 00:31:56 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Use ext[234]_bg_has_super() to remove duplicate code.

Would prefer one patch per filesystem, please.

After fixing the rejects, I now have patches which affect ext2 and ext3
but which have a merging dependency upon ext4.
