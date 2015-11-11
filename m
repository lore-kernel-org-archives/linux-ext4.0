From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: e2fsck -fD corruption of large htree/extent directory
Date: Wed, 11 Nov 2015 10:13:46 +0000
Message-ID: <D2685283.119F15%andreas.dilger@intel.com>
References: <D261A180.118DB8%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_D2685283119F15andreasdilgerintelcom_"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:18994 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbbKKKNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2015 05:13:49 -0500
In-Reply-To: <D261A180.118DB8%andreas.dilger@intel.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--_002_D2685283119F15andreasdilgerintelcom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CE858C520CDE714188394AD48CBA534E@intel.com>
Content-Transfer-Encoding: quoted-printable

On 2015/11/06, 00:12, "Dilger, Andreas" <andreas.dilger@intel.com> wrote:

>Running e2fsck -fD on a large extent+htree directory (> 300k entries,
>1600+ filesystem blocks) may result in the directory becoming corrupted.
>This is definitely caused by a bug in the code rather than hardware, as
>this corrupted multiple large directories on different systems.

Thanks to a suggestion from Darrick, I was able to reproduce this problem
with an e2fsck test script (attached) when shrinking an htree extent
directory with only 3 index blocks referenced directly by the inode.  The
problem is not present on block-mapped directories but looks to be a
danger for any user of the "-fD" option with extent-mapped directories.

It looks like the problem is if the inode shrinks enough that one of the
index blocks is dropped from the end of the file (blocks after logical
block 114 were freed), but the write_directory() write_dir_block()
iterator doesn't free the index block 800:
=01
    :
    write_dir_block 113:583 - write
    write_dir_block 114:587 - write
    write_dir_block 115:591 - free
    write_dir_block 116:595 - free
    :
    :
    write_dir_block 165:791 - free
    write_dir_block -1:800 - skip
    write_dir_block 166:795 - free
    write_dir_block 167:799 - free

    write_dir_block 168:804 - free
    write_dir_block 169:808 - free
    write_dir_block 170:812 - free
    write_dir_block 171:813 - free
    write_dir_block 172:814 - free
    write_dir_block -1:800 - skip
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information


The extent tree now has a bogus index block at the end, but somehow is
also missing the valid extent block that was holding the rest of the
file, as shown by debugfs (after "e2fsck -fD" but before the second
e2fsck that detects the corruption) and logical blocks 83-114 are lost:

    debugfs: stat subdir
    Inode: 12   Type: directory    Mode:  0755   Flags: 0x81000
    Generation: 0    Version: 0x00000000
    User:     0   Group:     0   Size: 117760
    File ACL: 0    Directory ACL: 0
    Links: 2   Blockcount: 238
    Fragment:  Address: 0    Number: 0    Size: 0
    ctime: 0x5642e764 -- Tue Nov 10 23:59:48 2015
    atime: 0x5642e764 -- Tue Nov 10 23:59:48 2015
    mtime: 0x5642e764 -- Tue Nov 10 23:59:48 2015
    EXTENTS:
    (ETB0):146, (0):129, (1):133, (2):137, (3):141, (4):145, (5):150,
    (6):154, (7):158, (8):162, (9):166, (10):170, (11):174, (12):178,
    (13):182, (14):186, (15):190, (16):194, (17):198, (18):202,
    (19):206, (20):210, (21):214, (22):218, (23):222, (24):226,
    (25):230, (26):234, (27):238, (28):242, (29):246, (30):250,
    (31):254, (32):258, (33):262, (34):266, (35):270, (36):274,
    (37):278, (38):282, (39):286, (40):290, (41):294, (42):298,
    (43):302, (44):306, (45):310, (46):314, (47):318, (48):322,
    (49):326, (50):330, (51):334, (52):338, (53):342, (54):346,
    (55):350, (56):354, (57):358, (58):362, (59):366, (60):370,
    (61):374, (62):378, (63):382, (64):386, (65):390, (66):394,
    (67):398, (68):402, (69):406, (70):410, (71):414, (72):418,
    (73):422, (74):426, (75):430, (76):434, (77):438, (78):442,
    (79):446, (80):450, (81):454, (82):458, (ETB0):800, (172):814


    debugfs: extents subdir
    :
    :
    1/ 1  82/ 83    81 -    81   454 -   454      1
    1/ 1  83/ 83    82 -    82   458 -   458      1
    0/ 1   2/  2   170 - 4294967410   800         4294967241
    1/ 1   1/  1   172 -   172   814 -   814      1










The i_size is correct for 115 data blocks written, and i_blocks would
be correct if the second index block wouldn't have been lost.  It seems
the bug is in the extent handling code, but I haven't yet dug into why
the last extent is kept.  I tried deleting it like the other blocks,
but the iteration immediately stops with an error that the index block
is corrupted, and I'm not sure how to catch it the second time.

Cheers, Andreas
--=20
Andreas Dilger

Lustre Principal Engineer
Intel High Performance Data Division



--_002_D2685283119F15andreasdilgerintelcom_
Content-Type: application/octet-stream; name="script"
Content-Description: script
Content-Disposition: attachment; filename="script"; size=1978;
	creation-date="Wed, 11 Nov 2015 10:13:46 GMT";
	modification-date="Wed, 11 Nov 2015 10:13:46 GMT"
Content-ID: <438BA844275D224A850CCE01E547BB1A@intel.com>
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKVE1QPSR7VE1QOi0iL3RtcCJ9CnRlc3RfbmFtZT0ke3Rlc3RfbmFtZTotJChi
YXNlbmFtZSAkKGRpcm5hbWUgJDApKX0KdGVzdF9kaXI9JHt0ZXN0X2RpcjotJHRlc3RfbmFtZX0K
Y21kX2Rpcj0ke2NtZF9kaXI6LSIuIn0KT1VUPSR0ZXN0X25hbWUubG9nCk1LRlM9JHtNS0ZTOi0u
Li9taXNjL21rZTJmc30KRlNDSz0ke0ZTQ0s6LS4uL2UyZnNjay9lMmZzY2t9CkRFQlVHRlM9JHtE
RUJVR0ZTOi0uLi9kZWJ1Z2ZzL2RlYnVnZnN9CgojIHBhcmFtZXRlcnMgZm9yIHJ1bl9lMmZzY2sK
U0tJUF9HVU5aSVA9InRydWUiCkZTQ0tfT1BUPSItZnl2RCIKCk5BTUVMRU49MjUwClNSQz0kVE1Q
LyR0ZXN0X25hbWUudG1wClNVQj1zdWJkaXIKQkFTRT0kU1JDLyRTVUIvJCh5ZXMgfCB0ciAtZCAn
XG4nIHwgZGQgYnM9JE5BTUVMRU4gY291bnQ9MSAyPiAvZGV2L251bGwpClRNUEZJTEU9JHtUTVBG
SUxFOi0iJFRNUC9pbWFnZSJ9CkJTSVpFPTEwMjQKCj4gJE9VVApta2RpciAtcCAkU1JDLyRTVUIK
IyBjYWxjdWxhdGUgdGhlIG51bWJlciBvZiBmaWxlcyBuZWVkZWQgdG8gY3JlYXRlIHRoZSBkaXJl
Y3RvcnkgZXh0ZW50IHRyZWUKIyBkZWVwIGVub3VnaCB0byBleGNlZWQgdGhlIGluLWlub2RlIGlu
ZGV4IGFuZCBzcGlsbCBpbnRvIGFuIGluZGV4IGJsb2NrLgojCiMgZGlyZW50cyBwZXIgYmxvY2sg
KiBleHRlbnRzIHBlciBibG9jayAqIChpbmRleCBibG9ja3MgPiBpX2Jsb2NrcykKTlVNPSQoKChC
U0laRSAvIChOQU1FTEVOICsgOCkpICogKEJTSVpFIC8gMTIpICogMikpCiMgQ3JlYXRlIHNvdXJj
ZSBmaWxlcy4gVW5mb3J0dW5hdGVseSBoYXJkIGxpbmtzIHdpbGwgYmUgY29waWVkIGFzIGxpbmtz
LAojIGFuZCBibG9ja3Mgd2l0aCBvbmx5IE5VTHMgd2lsbCBiZSB0dXJuZWQgaW50byBob2xlcy4K
aWYgWyAhIC1mICRCQVNFLjEgXTsgdGhlbgoJZm9yIE4gaW4gJChzZXEgJE5VTSk7IGRvCgkJZWNo
byAiZm9vIiA+ICRCQVNFLiROCglkb25lID4+ICRPVVQKZmkKCiMgbWFrZSBmaWxlc3lzdGVtIHdp
dGggZW5vdWdoIGlub2RlcyBhbmQgYmxvY2tzIHRvIGhvbGQgYWxsIHRoZSB0ZXN0IGZpbGVzCj4g
JFRNUEZJTEUKTlVNPSQoKE5VTSAqIDUgLyAzKSkKZWNobyAibWtlMmZzIC1iICRCU0laRSAtTyBk
aXJfaW5kZXgsZXh0ZW50IC1kJFNSQyAtTiROVU0gJFRNUEZJTEUgJE5VTSIgPj4gJE9VVAokTUtG
UyAtYiAkQlNJWkUgLU8gZGlyX2luZGV4LGV4dGVudCAtZCRTUkMgLU4kTlVNICRUTVBGSUxFICRO
VU0gPj4gJE9VVCAyPiYxCnJtIC1yICRTUkMKCiMgUnVuIGUyZnNjayB0byBjb252ZXJ0IGRpciB0
byBodHJlZSBiZWZvcmUgZGVsZXRpbmcgdGhlIGZpbGVzLCBhcyBta2UyZnMKIyBkb2Vzbid0IGRv
IHRoaXMuICBSdW4gc2Vjb25kIGUyZnNjayB0byB2ZXJpZnkgdGhlcmUgaXMgbm8gY29ycnVwdGlv
biB5ZXQuCigKCUVYUDE9JHRlc3RfZGlyL2V4cGVjdC5wcmUuMQoJRVhQMj0kdGVzdF9kaXIvZXhw
ZWN0LnByZS4yCglPVVQxPSR0ZXN0X25hbWUucHJlLjEubG9nCglPVVQyPSR0ZXN0X25hbWUucHJl
LjIubG9nCglERVNDUklQVElPTj0iJChjYXQgJHRlc3RfZGlyL25hbWUpIHNldHVwIgoJLiAkY21k
X2Rpci9ydW5fZTJmc2NrCikKCiMgZ2VuZXJhdGUgYSBsaXN0IG9mIGZpbGVuYW1lcyBmb3IgZGVi
dWdmcyB0byBkZWxldGUsIG9uZSBmcm9tIGVhY2ggbGVhZiBibG9jawpERUxFVEVfTElTVD0kVE1Q
L2RlbGV0ZS4kJAokREVCVUdGUyAtYyAtUiAiaHRyZWUgc3ViZGlyIiAkVE1QRklMRSAyPj4gJE9V
VCB8CglncmVwIC1BMiAiUmVhZGluZyBkaXJlY3RvcnkgYmxvY2siIHwKCWF3ayAnL3l5eXl5LyB7
IHByaW50ICJybSAnJFNVQicvIiQ0IH0nID4gJERFTEVURV9MSVNUCiRERUJVR0ZTIC13IC1mICRE
RUxFVEVfTElTVCAkVE1QRklMRSA+PiAkT1VUIDI+JjEKcm0gJERFTEVURV9MSVNUCmNwICRUTVBG
SUxFICRUTVBGSUxFLnNhdgoKLiAkY21kX2Rpci9ydW5fZTJmc2NrCg==

--_002_D2685283119F15andreasdilgerintelcom_--
