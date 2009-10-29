From: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Thu, 29 Oct 2009 17:25:17 -0400
Message-ID: <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
	 <20091016091558.GA10184@mit.edu>
	 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33958 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZJ2Va7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:30:59 -0400
In-Reply-To: <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 27, 2009 at 6:15 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> Can you try this patch ?
>
> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date: =A0 Tue Oct 27 15:36:38 2009 +0530
>
> =A0 =A0ext4: discard preallocation during truncate
>
> =A0 =A0We need to make sure when we drop and reacquire the inode's
> =A0 =A0i_data_sem we discard the inode preallocation. Otherwise we
> =A0 =A0could have blocks marked as free in bitmap but still belonging
> =A0 =A0to prealloc space.

Just wanted to let you know that I have applied this patch and one
unclean shutdown later it seems to have not given me any trouble.

I will continue testing it - hopefully I won't have to reformat  this
time ( every time I tested previously I ended up having weird issues
that I decided to get rid of by reformatting /).

Parag
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
