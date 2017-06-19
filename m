From: Danesh Daroui <danesh.daroui@gmail.com>
Subject: Re: Regression test (or generic tests) for Linux filesystems
Date: Mon, 19 Jun 2017 02:42:33 +0200
Message-ID: <CABjLfghjnf1RCq8mZccbFmbJmJE_qR+iDzP6rQ2pNhA6f-v5eQ@mail.gmail.com>
References: <CABjLfgi=TK6-od5GhL=VtzzLs0bV5GGBrgh2s9WvKaAn5YCCoA@mail.gmail.com>
 <30ec9f1e-f360-c634-727b-ce73e0f352ba@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <30ec9f1e-f360-c634-727b-ce73e0f352ba@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks for the clarification!

Regards,

Dan


On Sun, Jun 18, 2017 at 10:37 PM, Nikolay Borisov
<n.borisov.lkml@gmail.com> wrote:
>
>
> On 17.06.2017 20:45, Danesh Daroui wrote:
>> Hello all,
>>
>> Just a quick question. I am wondering if there is any test suite
>> available for ext4 fs or basic fs functionalists in Linux, shipped
>> with kernel as a module or so, then developers would be able to run
>> the test (or modify them for new features) to ensure fs integrity on a
>> local branch before submitting a patch for review?
>>
>> I have already found xfstests at:
>>
>> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/
>>
>> but I am not sure if this is the right one (haven't tried yet) or if
>> there is any better test suite even more specific tailored for ext4.
>
>
> xfstest is the de-facto testsuite for linux filesystems. It not only has
> generic tests but also fs-specific ones e.g. ext4. So go with it.
>
>>
>> Thanks for your answer,
>>
>> Dan
>>
