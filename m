From: Michael Rubin <mrubin@google.com>
Subject: Re: PATCH: Making mb_history length a dynamic tunable
Date: Sat, 18 Apr 2009 00:51:43 -0700
Message-ID: <532480950904180051m3226b309wc42cded4e73be028@mail.gmail.com>
References: <6601abe90904071020gdce65d2madc6df30c182c5cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:29858 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZDRHvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Apr 2009 03:51:46 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id n3I7pjTQ007238
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2009 00:51:45 -0700
Received: from rv-out-0506.google.com (rvbg37.prod.google.com [10.140.83.37])
	by wpaz33.hot.corp.google.com with ESMTP id n3I7phDd005845
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2009 00:51:44 -0700
Received: by rv-out-0506.google.com with SMTP id g37so72482rvb.41
        for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2009 00:51:43 -0700 (PDT)
In-Reply-To: <6601abe90904071020gdce65d2madc6df30c182c5cd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 7, 2009 at 10:20 AM, Curt Wohlgemuth <curtw@google.com> wro=
te:
> Hi:
>
> Since we frequently run in memory-constrained systems with many parti=
tions,
> the ~68K for each partition for the mb_history buffer can be excessiv=
e. =A0The
> following creates a new proc file under /proc/fs/ext4/ to control the=
 number
> of entries at mount time.
>
> If the notion of a history length tunable is okay, but the location s=
hould
> be under /sys/fs/ext4/ instead of /proc/fs/ext4/, I can change this. =
=A0The
> leftover files under /proc/fs/ext4/<partition>/ are a bit confusing t=
o me.
>

Does the silence mean that there is no interest in this CL?

We thought making this a run time tunable would be cool.

mrubin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
