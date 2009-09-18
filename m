From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 2/2] ext4: Handle nested ext4_journal_start/stop calls
	without a journal
Date: Fri, 18 Sep 2009 11:33:04 -0700
Message-ID: <6601abe90909181133g27458301nb3aae756e473541c@mail.gmail.com>
References: <6601abe90909171455g597fe672g1ca6d426e609f937@mail.gmail.com>
	 <20090918055010.GN2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:44041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940AbZIRSdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 14:33:05 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id n8IIX7oI009058
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 11:33:07 -0700
Received: from pxi36 (pxi36.prod.google.com [10.243.27.36])
	by spaceape9.eur.corp.google.com with ESMTP id n8IIVjbD001691
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 11:33:04 -0700
Received: by pxi36 with SMTP id 36so929378pxi.6
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 11:33:04 -0700 (PDT)
In-Reply-To: <20090918055010.GN2537@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 17, 2009 at 10:50 PM, Andreas Dilger <adilger@sun.com> wrot=
e:
> On Sep 17, 2009 =A014:55 -0700, Curt Wohlgemuth wrote:
>> This patch fixes a problem with handling nested calls to
>> ext4_journal_start/ext4_journal_stop, when there is no journal prese=
nt.
>>
>> =A0 =A0 =A0 Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>> ---
>>
>> Instead of using the special value of
>>
>> =A0 =A0 =A0 =A0 (handle_t *)0x1
>>
>> to represent a handle when there is no journal present, we now use a=
 real
>> handle_t, so we can use its ref counting. =A0The h_transaction field=
 now
>> determines if there is a journal present or not.
>
> You _could_ just use the "handle" value as a refcount, and anything l=
ess
> than, say, 4096 is considered a "special" handle. =A0I can't imagine =
the
> refcount being more than 3 or 4 even in extreme cases.

That's an elegant idea; thanks.  I'll work this up and send a patch out=
 for it.

Thanks,
Curt

>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
