From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Do not convert to indirect with bigalloc enabled
Date: Tue, 9 Apr 2013 15:28:54 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304091527440.22989@localhost>
References: <1365070685-5088-1-git-send-email-lczerner@redhat.com> <20130408061011.GB328@gmail.com> <20130409132313.GC12050@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab3DIN27 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 09:28:59 -0400
In-Reply-To: <20130409132313.GC12050@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Apr 2013, Theodore Ts'o wrote:

> Date: Tue, 9 Apr 2013 09:23:13 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: Do not convert to indirect with bigalloc enabled
> 
> Thanks, applied.

Ted you probably want to apply the series I sent earlier today
containing this patches.

[PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
[PATCH 2/2 v2] ext4: Do not convert to indirect with bigalloc enabled

Thanks!
-Lukas

> 
> 					- Ted
> 
