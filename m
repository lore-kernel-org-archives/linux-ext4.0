From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: EXT4-fs (device loop0): panic forced after error -- bug or not?
Date: Tue, 1 Dec 2015 15:22:02 +0100
Message-ID: <565DAD0A.6030305@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030108040901020900060006"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48286 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbbLAOWL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Dec 2015 09:22:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030108040901020900060006
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Using the attached fuzzed ext4 image, I get the following panic on
latest linus/master.

I'm a bit unsure about whether this is really a bug or not; it looks
like the filesystem is set to panic on error but I still find it weird
that this behaviour is allowed by default (would it still panic if
somebody inserted this filesystem on a USB stick and it got automounted?).

I call mount() with mountflags=0 and data=NULL followed by opendir() and
readdir(), but if I just a manual mount + ls from the shell I don't see
the panic at all, just some of the errors, so I thought maybe there's
some sort of race somewhere?

Anyway, here's the log:

[EXT4 FS bs=1024, gc=2, bpg=8192, ipg=2048, mo=a802ec48, mo2=0002]
System zones: 1-2, 66-67, 82-83, 98-609, 8193-8194
EXT4-fs (loop0): mounted filesystem with writeback data mode. Opts: (null)
EXT4-fs warning (device loop0): dx_probe:782: inode #2: comm mount.exe: 
dx entry: limit 46 != root limit 125
EXT4-fs warning (device loop0): dx_probe:853: inode #2: comm mount.exe: 
Corrupt directory, running e2fsck is recommended
EXT4-fs error (device loop0): ext4_readdir:224: inode #2: block 68: comm 
mount.exe: path /mnt/ext4: bad entry in directory: rec_len is smaller 
than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
Aborting journal on device loop0-8.
Kernel panic - not syncing: EXT4-fs (device loop0): panic forced after error

CPU: 1 PID: 971 Comm: mount.exe Not tainted 4.4.0-rc3+ #244
  ffff88001580adf0 ffff880015df7960 ffffffff81610cc9 ffffffff820a4540
  ffff880015df7a28 ffffffff811aaf62 0000000041b58ab3 ffffffff824627f4
  ffffffff811aae32 ffff880015df79d0 ffffffff00000010 ffff880015df7a38
Call Trace:
  [<ffffffff81610cc9>] dump_stack+0x44/0x5b
  [<ffffffff811aaf62>] panic+0x130/0x279
  [<ffffffff811aae32>] ? set_ti_thread_flag+0xf/0xf
  [<ffffffff8132f2ec>] ext4_handle_error.part.196+0x11c/0x120
  [<ffffffff8132f8a1>] __ext4_error_file+0x181/0x300
  [<ffffffff8132f720>] ? __ext4_error_inode+0x2b0/0x2b0
  [<ffffffff8127dc0d>] ? __find_get_block+0x13d/0x170
  [<ffffffff81282066>] ? __getblk_gfp+0x26/0x60
  [<ffffffff812f95e4>] ? ext4_getblk+0x104/0x270
  [<ffffffff812f94e0>] ? ext4_get_block_write_nolock+0x10/0x10
  [<ffffffff81617c7d>] ? radix_tree_lookup+0xd/0x10
  [<ffffffff812ecf90>] __ext4_check_dir_entry+0x150/0x220
  [<ffffffff812ed66c>] ext4_readdir+0x60c/0x1150
  [<ffffffff812ed060>] ? __ext4_check_dir_entry+0x220/0x220
  [<ffffffff8157c067>] ? selinux_file_permission+0x177/0x1d0
  [<ffffffff8124ac24>] iterate_dir+0x104/0x1e0
  [<ffffffff8124aed6>] SyS_getdents+0xe6/0x160
  [<ffffffff8124adf0>] ? SyS_old_readdir+0xf0/0xf0
  [<ffffffff8124a710>] ? SyS_ioctl+0x80/0x80
  [<ffffffff8106fc25>] ? trace_do_page_fault+0x45/0xf0
  [<ffffffff81f7d82e>] entry_SYSCALL_64_fastpath+0x12/0x71

Beware that the filesystem image changes after mounting and the
resulting filesystem doesn't panic again AFAICT, so it's better to make
a fresh copy before mounting.

I can test patches. Thanks,


Vegard

--------------030108040901020900060006
Content-Type: application/x-bzip;
 name="ext4.0.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ext4.0.bz2"

QlpoOTFBWSZTWb/ID3EAAJt//////////////2U9Ez/Pn7D0QqPJ1uqxp95BTgfs97//0AVT
1JlgABkGqHEU9SajQA0AAAAaAAaAGjQNNDRoxAAAAHvVIAAAAAAANAAAyIKACn6pp6R6ah6j
QeoDRo0DTQAGgBoaND0IyPUAAAAAAAAANGgAHqINNDIDJpoDE0BoaZA0GmEZNBkMmQBgQNMR
oMhgE00GIaABk0MmAjQaNCA0Mg0yaaBhNAaGmTRpgRkZNBkMmQZGmRo0yDRoAYI00GIaABk0
MmAjQaNAiUU0EaTJMmajIGEaZMgYjEAeppoGmg0aMgA9EGgDQA0AAGgzSaaPUNNDTaamQ2GN
vwY8J80KS8D904mqAKIGNZGMA/zztHES091BSfsgimUFMYynidOOgOta8w6mDe+F3sDYVSMe
Fs4zWOQGTuQ+IKZi3DZzNwu5mwqjnoqdHBvxTEiAbO9SMBCZIUWiPSHMC9qese//H9OkbzhX
hW590WzfXoG0XMQGYhAKoAETAgIoh9EFRUXNRBkBAEBd1FBAUBNNEUBF22ABrLyKaqFiQQRN
F9FXWKSWBAzBtqAKT6VFatmFiQriMCBCQGXGkE4GAFxY5Qa1AK5CTBkECg1ttkmCXJE1TNgG
ToBoVABoIQEQAEjqaZJCZDCEPJmkZKsoIAln2XmJRgmRmks3EnBOO5iQUxwTomTwhPjQJaFA
YCeiNUUZtIIUov6mLBSFNTqkIVFSrWHLaqrrDq1aFtUtrdRRrjZMr4QTLImVDGlgaNIWLmS0
KLQ6Iq42LhENa7GxexjsWFIJZExibaDgRUBQAA6e3jNXiaOhpCK3IGrgqbGCzsqCUiMjmSIU
gSBIuulwtHlVbxSiXCDcjbINIyBIyEjISDIyMkgSSEjIEhIEjIyEkgSMjIyMhIkkkjyrSkkh
IyDIEiySBhJAA7yZyMMJo2uevFSpWNFS+wAtETRQIREBQAArNpMCAWFqhoc6tAC1Eu2EwTBL
TYEEbYxW3CwsqVgsFHqojryArWINoiINIChoCCgAgAFDOlChCu+oYLHPOo9cmRv+4LaTyYFD
CL5oGczUx7ZA4UQuFo5Q85qh8G7ooYpgUQvkdHAz8ANObm+YcLQl6A4i1WobQtOpPh4eK3C8
XTKgWBkl54GQFEvzk4CaDIrsrLDPQ/yOHLpt8TSu6sG2R1BDnDn6P8RaEPqYJQ42YKrUoVqZ
8jpmFCEQi7eOrg7Cc7BsKEKG4hy7wqF+cfg0c4RVtQxCYZl4ZUNo49Mxl/3Uy48Vjfi66Acr
H9hdhBgEwOkQ9BXivAQRC0+niC84AZAEHizRK0SNUkMvld6gvlFZazWDCI3KCjMRapi1ySBX
LoanInCpqyIiTERFKERWpJzz1h559afeFLOmZqvzp8E0kANeQOniakIm2j8ZOPExditKDKLH
vTUmKfYWh1jyVA/AiGaCZMO77OgZqfhvSmfZgy2f7xGoHFjzm7lG5B2o2yj636yi+wE603dH
eeJQ9wIGQwHMsZ2bkKOugAb5/VRfL6R9tuusPZOAQv8zF5fSlSvBOb+84JknN5gvG1OeMAwy
BifmYNl+6dKXTJEkXZaHyRFF0wKJQDpwQQC6CiOLWAwhVXmqIFC5UvMDNw6ZgNYRccg4+X4N
XX91r607fnfjD+jtAt71RcVUBgQoBWJZUitMzxPN2W24iLY6/mgpc7EOL8ipxouAFHZBNri5
X77+wwOOE4tQy4nDe24w/UHfWbP8gxqh4+U8QNwHqWYkytVm8YtGSwNZiC0809UxTLzkllll
DCw6GKEQAUAAKhNFN47mjp4cbkXNDOaj6ZhFA492i8hiBhxSrBDqoDSK8LkVzOjp/08AwJsP
vtF7T63YV0oDPASf+LuSKcKEhf5Ae4g=
--------------030108040901020900060006--
