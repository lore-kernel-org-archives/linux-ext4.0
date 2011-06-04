From: Amir Goldstein <amir73il@gmail.com>
Subject: Google summer of snapshots
Date: Sat, 4 Jun 2011 22:59:13 +0300
Message-ID: <BANLkTi=CSkkZGo_g18QnLR_nnz-MH-veQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andres Toomsalu <andres@active.ee>,
	harshad shirwadkar <harshadshirwadkar@gmail.com>,
	sergey ivanov <sergey57@gmail.com>,
	Shardul Mangade <shardul27@gmail.com>,
	Arvin Schnell <arvin.schnell@opensuse.org>,
	Piyush Nimbalakar <piyushmnimbalkar@gmail.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Aditya Dani <aditya.dani@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37427 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1FDT7R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Jun 2011 15:59:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I am posting this update to fill you in on some work related
to filesystem snapshots, which is going to be carried out this summer.
I am also posting the contacts of the people involved, in case
any of you are interested in more details about their work.

Some of you may have attended my talk on LSF about the status
of (filesystem) snapshots and future improvements.

Part of the talk was focused on some technical and administrative
challenges, which snapshotting file systems drag along, like disk
quota management and out-of-space error handling.

Another part was dedicated to examples of applications, which could
leverage filesystem snapshots into something more than a cool
sounding feature.

The examples I gave were:
1. Revert to snapshot by installers (Yum already utilizes btrfs snapshots)
2. Hot (incremental) backup of a live filesystem to a remote
    system by sending the snapshot diffs (e.g. ZFS send/recv)
3. Generic snapshot manager, which is agnostic to the underlying
    filesystem.
4. Automated tests for snapshots (not an application per-se, but
    something we are lacking)

By sheer luck, LSF was rolling on the same week that Google summer
of code applications could be submitted, a fact which I had learned just a
short time before the submission deadline.

Quickly and not subtly I had urged 4 students, who were previously
engaged in the porting of next3 snapshots to ext4, to submit project
proposals for the 4 applications mentioned above.

In the following weeks I had recruited 4 mentors for each of the projects
and eventually, all projects got accepted by Google :-)

Following are the supporting organization, mentor and student for each project:
1. Revert to ext4/LVM snapshot support in Yum: Fedora, Andres
Toomsalu, Harshad Shirwadkar
2. Hot filesystem backup with ext4 snapshots: Linux Foundation, Sergey
Ivanov, Shardul Mangade
3. Add ext4 support for snapper snapshot manager: openSUSE, Arvin
Schnell, Piyush Nimbalakar
4. Add snapshot related tests to xfstest: openSUSE, Greg Freemyer, Aditya Dani

I addition to the 4 snapshot application projects, we also continue to
improve ext4 snapshots:
5. Auto defrag in ext4 snapshots: Linux Foundation, Amir Goldstein,
Yongqiang Yang

Ext4 snapshots patches were planned for merging in the 3.0 merge
window, but did not
make it in, partly due to lack of sufficient review.
We do hope they will get reviewed and merged for the next merge window.

The core patches are available for online review on github:
https://github.com/amir73il/ext4-snapshots/commits/for-ext4

A stand-alone ext4dev module (for kernel 2.6.38) and utils for testing
ext4 snapshots
are available for download on http://next3.sf.net/

I wish all the students a great summer of coding!

Amir.
