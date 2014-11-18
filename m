From: Steve French <smfrench@gmail.com>
Subject: Re: xfstests and ext4
Date: Mon, 17 Nov 2014 20:35:39 -0600
Message-ID: <CAH2r5mti8hVXqmKu9kJg4Xk=5nkESCAQys1BFXhR6JSDVHOTEA@mail.gmail.com>
References: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
 <20141114000216.GN28565@dastard> <CAH2r5mvi2LijxWia2sCf+em7rfPtBn_fg6WKU=aftVUTuzXMgw@mail.gmail.com>
 <20141117203804.GO23575@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:61846 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaKRCgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2014 21:36:00 -0500
In-Reply-To: <20141117203804.GO23575@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 17, 2014 at 2:38 PM, Dave Chinner <david@fromorbit.com> wrote:

> the other as a base64 encoded attachment so can't be quoted and
> replied to easily. In future, can you send patches as separate
> emails according to:

Yes.  WIll do.  It is a pain in test  VMs to setup git with gmail two
phase authentication
but doable if I set it up to send mail from a different host.

>>  Building Linux:
>>      - cd into the xfstests directory
>> +    - install prerequisite packages
>> +      For example, for Ubuntu:
>> +        "sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs
>> +         automake gcc libuuid1 libuuidm-ocaml-dev attr libattr1-dev
>                                   ^^^^^^^^^^^^^^^^^^
>
> What in xfstests is dependent on ocaml?

That libuuidm-ocaml-dev looks unneeded now (I ended up pulling in one
of the tools a different
way so whatever that pulled in looks superfluous now) - in an earlier
try at this I built a few
of the tools. But there is one missing. I missed in the cut-and-pastes
an obvious very
important dependency when I was transcribing the dependency list -
"quota"   I will add
that to the list and remove the libuuidm-ocaml-dev off now that I have
confirmed the dependencies
list again today on a fresh Ubuntu install.



-- 
Thanks,

Steve
