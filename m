From: Danesh Daroui <danesh.daroui@gmail.com>
Subject: Regression test (or generic tests) for Linux filesystems
Date: Sat, 17 Jun 2017 19:45:17 +0200
Message-ID: <CABjLfgi=TK6-od5GhL=VtzzLs0bV5GGBrgh2s9WvKaAn5YCCoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello all,

Just a quick question. I am wondering if there is any test suite
available for ext4 fs or basic fs functionalists in Linux, shipped
with kernel as a module or so, then developers would be able to run
the test (or modify them for new features) to ensure fs integrity on a
local branch before submitting a patch for review?

I have already found xfstests at:

https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/

but I am not sure if this is the right one (haven't tried yet) or if
there is any better test suite even more specific tailored for ext4.

Thanks for your answer,

Dan
