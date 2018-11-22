Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38882 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbeKVKob (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 05:44:31 -0500
Date: Wed, 21 Nov 2018 19:07:49 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: alexey.lyashkov@gmail.com
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] add support to check a journal checksum v1 while
 journal dump.
Message-ID: <20181122000749.GF10588@thunk.org>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
 <20181119091650.81803-4-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119091650.81803-4-alexey.lyashkov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2018 at 12:16:50PM +0300, alexey.lyashkov@gmail.com wrote:
> 
> journal checksum v1 cover an all blocks in journal descriptor.
> This checksum stored into commit block and check with commit
> block reading.

I'm really curious --- why do you care about journal_checksum v1 at
all?  It rarely used, and the journal_checksum v3 is much superior.

      	 	       	     	     		      - Ted
						      
