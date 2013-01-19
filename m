From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Sun, 20 Jan 2013 00:44:31 +0100
Message-ID: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b6777f239b54204d3accf13
Cc: Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--047d7b6777f239b54204d3accf13
Content-Type: text/plain; charset=UTF-8

Hi,

I and some others hit a similiar problem in Linux-Next
(next-20130118), please see [1] and [2].

[3] has a interim analyze of my problems.

After suspecting the problem was caused by TTY-NEXT, it turned out to
be a JBD2 problem finally.
The freezer/pm_test was helpful to hit the issue (Thanks Rafael for the hint!).

So, the issue has two faces: TTY and JBD2.
[4] gives a list and URLs of the patches I had to apply to have a
clean system again.

After applying the two TTY patches (without Eric's JBD2-fix!) the
call-trace after freezer/pm_test looked like this;

[  433.527986] PM: Syncing filesystems ... done.
[  433.843761] PM: Preparing system for mem sleep
[  436.306002] Freezing user space processes ...
[  456.304956] Freezing of tasks failed after 20.01 seconds (1 tasks
refusing to freeze, wq_busy=0):
[  456.305060] Cache I/O       D ffffffff8180d780     0  2132      1 0x00000004
[  456.305065]  ffff88007b9dfe18 0000000000000046 ffff88007b9dfdc8
0000000300000001
[  456.305069]  ffff880097e21720 ffff88007b9dffd8 ffff88007b9dffd8
ffff88007b9dffd8
[  456.305072]  ffff880119b32e40 ffff880097e21720 ffff88007b9dfe28
ffff880118077800
[  456.305076] Call Trace:
[  456.305085]  [<ffffffff816b7469>] schedule+0x29/0x70
[  456.305089]  [<ffffffff8129067d>] jbd2_log_wait_commit+0xcd/0x1a0
[  456.305094]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
[  456.305098]  [<ffffffff812307a5>] ext4_sync_file+0x205/0x380
[  456.305103]  [<ffffffff811c43ad>] do_fsync+0x5d/0x90
[  456.305108]  [<ffffffff8119442b>] ? sys_write+0x6b/0xa0
[  456.305111]  [<ffffffff811c4790>] sys_fsync+0x10/0x20
[  456.305114]  [<ffffffff816c0edd>] system_call_fastpath+0x1a/0x1f
[  456.305122]
[  456.305124] Restarting tasks ... done.
[  456.315056] video LNXVIDEO:00: Restoring backlight state

After applying Eric's patch [5], I could not hit the call-trace again.
NOTE: The patch is from December 2012 and is not shipped in latest Linux-Next.

The attached testcase script was helpful to force the call-trace.
I have run 50 loops of it w/o an issue!

Feel free to add a Reported-by/Tested-by.
( The issue kept me busy for the last days. )

Regards,
- Sedat -

[1] http://marc.info/?t=135283664600002&r=1&w=2
[2] http://marc.info/?t=135862023700004&r=1&w=2
[3] http://marc.info/?l=linux-kernel&m=135862010419101&w=2
[4] http://marc.info/?l=linux-next&m=135863550923093&w=2
[5] http://patchwork.ozlabs.org/patch/207237/

--047d7b6777f239b54204d3accf13
Content-Type: application/x-sh; name="run_pm-test_v2.sh"
Content-Disposition: attachment; filename="run_pm-test_v2.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hc5e8oim0

IyEvYmluL2Jhc2gKCiMgSEVMUAojIFsxXSBodHRwOi8vZ2l0Lmtlcm5lbC5vcmcvP3A9bGludXgv
a2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQ7YT1ibG9iO2Y9RG9jdW1lbnRhdGlvbi9wb3dl
ci9iYXNpYy1wbS1kZWJ1Z2dpbmcudHh0CiMgWzJdIGh0dHA6Ly9naXQua2VybmVsLm9yZy8/cD1s
aW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdDthPWJsb2I7Zj1Eb2N1bWVudGF0aW9u
L3Bvd2VyL2ZyZWV6aW5nLW9mLXRhc2tzLnR4dAoKIyBQUkVSRVE6IEtlcm5lbCBERUJVRyBvcHRp
b25zCiMgQ09ORklHX1BNX0RFQlVHPXkKIyBDT05GSUdfRVhUNF9ERUJVRz15CiMgQ09ORklHX0pC
RDJfREVCVUc9eQoKZXhwb3J0IExBTkc9QwpleHBvcnQgTENfQUxMPUMKCiMgRGVmYXVsdCB2YWx1
ZSBvZiBodW5nX3Rhc2tfdGltZW91dF9zZWNzIGlzIDEyMCBbc2Vjc10KU0VDUz0iMCIKCiMgUG9z
c2libGUgdHlwZXM6IG5vbmUgY29yZSBwcm9jZXNzb3JzIHBsYXRmb3JtIGRldmljZXMgZnJlZXpl
cgpQTV9URVNUX1RZUEU9ImZyZWV6ZXIiCgojIENvdW50ZXIgYW5kIGxvb3BzCkNPVU5URVI9IjAi
CkxPT1BTPSIxMCIKCmVjaG8gIiRTRUNTIiA+IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3Rp
bWVvdXRfc2VjcwoKZWNobyAiJFBNX1RFU1RfVFlQRSIgPiAvc3lzL3Bvd2VyL3BtX3Rlc3QKCndo
aWxlIFsgJENPVU5URVIgLWx0ICRMT09QUyBdOyBkbwogICAgZWNobyBbIHBtX3Rlc3QvZnJlZXpl
cjogUnVuICRDT1VOVEVSIF0KICAgIGVjaG8gbWVtID4gL3N5cy9wb3dlci9zdGF0ZSAmJiBzbGVl
cCAxCiAgICBlY2hvIFsgcG1fdGVzdC9mcmVlemVyOiBPSyAkQ09VTlRFUiBdCiAgICBsZXQgQ09V
TlRFUj1DT1VOVEVSKzEKZG9uZQo=
--047d7b6777f239b54204d3accf13--
