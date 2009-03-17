From: Chris Worley <worleys@gmail.com>
Subject: Re: Overwriting w/ discard-capable drive causes soft-lockup in ext4
	journal code, 2.6.28.8
Date: Tue, 17 Mar 2009 13:19:33 -0600
Message-ID: <f3177b9e0903171219l2cd6ef84g5416275e999132be@mail.gmail.com>
References: <f3177b9e0903171029l13e7dbafyba30ece01172ce6d@mail.gmail.com>
	 <49BFE572.9020302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:3800 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZCQTTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Mar 2009 15:19:35 -0400
Received: by wf-out-1314.google.com with SMTP id 29so144467wff.4
        for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 12:19:33 -0700 (PDT)
In-Reply-To: <49BFE572.9020302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 17, 2009 at 12:01 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> Chris Worley wrote:
>> The issue I'm seeing is caused by running this repeatedly on an ext4
>> fs (2.6.28.8 kernel) w/ discards enabled (a ram-based MTD device
>> contains the fs):
>>
>> while `true`
>> do =A0i=3D0
>> =A0 =A0 =A0while [ $i -lt 100 ]
>> =A0 =A0 =A0do dd of=3Dfoo"$i" if=3D/dev/zero bs=3D1024k oflag=3Ddire=
ct &
>> =A0 =A0 =A0 =A0 =A0 let i=3D$i+1
>> =A0 =A0 =A0done
>> =A0 =A0 =A0wait
>> done
>>
>> (Note: the loop is intended to fill-up the fs w/ 100 dd threads...
>> successive re-runs of the loop will rewrite the same files from
>> scratch.)
>>
>> ... It causes "soft-lockup" issues on successive iterations,
>> immediately as the DD's are launched, as previous foo files get thei=
r
>> blocks discarded.
>
> I need to find a machine w/ more memory to test on :) =A0but with a d=
evice
> of half that size, on 2.6.29-rc7 machine w/ 2 cpus and 2G ram, I'm no=
t
> seeing it...
>
> Any chance you can try a 2.6.29-rcX kernel just to double-check?

I'm not able to repeat w/ 2.6.29-rc8.

The system just limps-along, though; SATA doesn't work, Ethernet
doesn't work, and system response is slow... but disk speed is as
expected, and no soft-lockup issues.

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
