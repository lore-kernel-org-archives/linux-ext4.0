From: Steve French <smfrench@gmail.com>
Subject: xfstest generic/018 and ext4 defrag
Date: Thu, 13 Nov 2014 15:16:30 -0600
Message-ID: <CAH2r5mvAGe-N0e2rOsEe4DBT1tRM0Uv8rNQChmQY+d7dkLxR2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I see an earlier thread about ext4 defrag problems causing this
failure on xfstest generic/018 running on ext4

generic/018 1s ... [failed, exit status 1] - output mismatch (see
/home/sfrench/xfstests/results//generic/018.out.bad)
    --- tests/generic/018.out 2014-11-13 11:20:05.385406288 -0800
    +++ /home/sfrench/xfstests/results//generic/018.out.bad 2014-11-13
12:33:19.317806287 -0800
    @@ -10,10 +10,5 @@
     After: 1
     Write backwards sync, but contiguous - should defrag to 1 extent
     Before: 10
    -After: 1
    -Write backwards sync leaving holes - defrag should do nothing
    -Before: 16
    -After: 16
    ...

but wasn't clear whether it was fixed upstream.  It failed on two out
of three runs for me on most current ext4.  My test is on most current
Ubuntu x86_64  (and with 3.18-rc3 kernel)
I couldn't find version info for e4defrag from the command line but
other ext4 tools are reasonably recent it seems as Ubuntu packages
them e.g. EXT2FS Library version 1.42.10, 18-May-2014

Is generic xfstest 18 still broken on ext4?

Also am curious about test generic/026

generic/026  [not run] ext4 does not define maximum ACL count

Is that expected?
-- 
Thanks,

Steve
