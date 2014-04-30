From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
Date: Wed, 30 Apr 2014 11:26:23 -0400
Message-ID: <20140430152623.GG9213@thunk.org>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
 <1398556834-31913-4-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1404301410590.2100@localhost.localdomain>
 <20140430140657.GB9213@thunk.org>
 <alpine.LFD.2.00.1404301611290.2100@localhost.localdomain>
 <20140430141815.GE9213@thunk.org>
 <alpine.LFD.2.00.1404301628010.2100@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42118 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbaD3P00 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 11:26:26 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404301628010.2100@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2014 at 04:35:12PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> But having mkfs to print out the information that it's actually
> creating the file is the least we can do.

Agreed, that sounds like a good compromise.  I'll do that.

	     	    	   		     - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
