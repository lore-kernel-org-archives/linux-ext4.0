From: Chris Worley <worleys@gmail.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 10:30:09 -0600
Message-ID: <f3177b9e0905110930p3fe180b0nbd26bd24f17b068e@mail.gmail.com>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu>
	 <20090511100624.GB6585@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:51108 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZEKQaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 12:30:08 -0400
In-Reply-To: <20090511100624.GB6585@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 4:06 AM, J=F6rn Engel <joern@logfs.org> wrote:
>
> I am not sure about this part. =A0So far Intel has been the only part=
y to
> release any information about their dark-grey box. =A0All other boxes=
 are
> still solid black. =A0And until I'm told otherwise I'd consider them =
to be
> stupid devices that use erase block size as trim granularity.

Consider yourself informed otherwise: I can't imagine a vendor
brain-dead enough to require that.  It's the same thing as requiring
that the only way to re-write an LBA is to re-write all LBA's in the
same erase block.

Note that Fusion-io supports "discard" in their released 1.2.5 drivers.

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
