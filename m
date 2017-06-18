From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Re: Regression test (or generic tests) for Linux filesystems
Date: Sun, 18 Jun 2017 23:37:16 +0300
Message-ID: <30ec9f1e-f360-c634-727b-ce73e0f352ba@gmail.com>
References: <CABjLfgi=TK6-od5GhL=VtzzLs0bV5GGBrgh2s9WvKaAn5YCCoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Danesh Daroui <danesh.daroui@gmail.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CABjLfgi=TK6-od5GhL=VtzzLs0bV5GGBrgh2s9WvKaAn5YCCoA@mail.gmail.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 17.06.2017 20:45, Danesh Daroui wrote:
> Hello all,
> 
> Just a quick question. I am wondering if there is any test suite
> available for ext4 fs or basic fs functionalists in Linux, shipped
> with kernel as a module or so, then developers would be able to run
> the test (or modify them for new features) to ensure fs integrity on a
> local branch before submitting a patch for review?
> 
> I have already found xfstests at:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/
> 
> but I am not sure if this is the right one (haven't tried yet) or if
> there is any better test suite even more specific tailored for ext4.


xfstest is the de-facto testsuite for linux filesystems. It not only has
generic tests but also fs-specific ones e.g. ext4. So go with it.

> 
> Thanks for your answer,
> 
> Dan
> 
