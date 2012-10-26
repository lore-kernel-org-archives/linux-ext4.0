From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Fri, 26 Oct 2012 15:35:06 -0500
Message-ID: <508AF3FA.4020506@redhat.com>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org, linux-nfs@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87pq48nbyz.fsf_-_@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/23/12 3:57 PM, Nix wrote:
> [Bruce, Trond, I fear it may be hard for me to continue chasing this NFS
>  lockd crash as long as ext4 on 3.6.3 is hosing my filesystems like
>  this. Apologies.]

<big snip>

> The only unusual thing about the filesystems on this machine are that
> they have hardware RAID-5 (using the Areca driver), so I'm mounting with
> 'nobarrier': the full set of options for all my ext4 filesystems are:
> 
> rw,nosuid,nodev,relatime,journal_checksum,journal_async_commit,nobarrier,quota,
> usrquota,grpquota,commit=30,stripe=16,data=ordered,usrquota,grpquota

Out of curiosity, when I test log replay with the journal_checksum option, I
almost always get something like:

[  999.917805] JBD2: journal transaction 84121 on dm-1-8 is corrupt.
[  999.923904] EXT4-fs (dm-1): error loading journal

after a simulated crash & log replay.

Do you see anything like that in your logs?

<big snip>

Thanks,
-Eric
