Return-Path: <SRS0=9ApQ=RO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05977C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 00:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9147520657
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 00:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="oicLnPqJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbfCKAX4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Mar 2019 20:23:56 -0400
Received: from mail-eopbgr810094.outbound.protection.outlook.com ([40.107.81.94]:27424
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726895AbfCKAX4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Mar 2019 20:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FCakAya/H22oDvx5j6vk1HyEIreWtI9I5WVHKUmM2Q=;
 b=oicLnPqJqL5j9VS9BBRTepZ/B7NdW202E3Ou3hqBjxBULW0tZxW0LxgPNvMwi5CrafzEECQlVPTN1bRoIgIj/DNXUlA2vaw7++i84uE18R6gIQ+YfEvqs3juo1bqJvmsps4GToPSeztSqhfjEB0wC7559e7RC1CVWkq45mkNqsA=
Received: from MN2PR01CA0007.prod.exchangelabs.com (2603:10b6:208:10c::20) by
 MWHPR01MB2478.prod.exchangelabs.com (2603:10b6:300:3e::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.19; Mon, 11 Mar 2019 00:22:12 +0000
Received: from DM3NAM03FT040.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::204) by MN2PR01CA0007.outlook.office365.com
 (2603:10b6:208:10c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.16 via Frontend
 Transport; Mon, 11 Mar 2019 00:22:11 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT040.mail.protection.outlook.com (10.152.83.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.19 via Frontend Transport; Mon, 11 Mar 2019 00:22:11 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2B0M8ON029265
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Mar 2019 20:22:09 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 72CA24236BB; Sun, 10 Mar 2019 20:22:08 -0400 (EDT)
Date:   Sun, 10 Mar 2019 20:22:08 -0400
From:   Theodore Ts'o <tytso@mit.edu>
To:     Sven Hartge <sven@svenhartge.de>, <924275@bugs.debian.org>
CC:     <linux-ext4@vger.kernel.org>, <darrick.wong@oracle.com>,
        <control@bugs.debian.org>
Subject: Re: Bug#924275: Pulls in lvm2 packages on systems not needing them
Message-ID: <20190311002208.GA4486@mit.edu>
References: <155224974445.827475.8622512417054538613.reportbug@ds9.feds.ath.cx>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <155224974445.827475.8622512417054538613.reportbug@ds9.feds.ath.cx>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(376002)(346002)(2980300002)(189003)(199004)(106466001)(8676002)(58126008)(76176011)(316002)(126002)(478600001)(476003)(42186006)(2906002)(486006)(246002)(16586007)(88552002)(86362001)(229853002)(106002)(110136005)(90966002)(2476003)(568964002)(33656002)(54906003)(44144004)(26005)(103686004)(1076003)(4326008)(6266002)(71190400001)(84326002)(5000100001)(14444005)(356004)(36756003)(6246003)(5024004)(186003)(63394003)(5660300002)(235185007)(75432002)(26826003)(446003)(786003)(2616005)(305945005)(11346002)(8936002)(336012)(36906005)(52956003)(2700100001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR01MB2478;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6877732e-d5cb-4e81-1d9f-08d6a5b79aeb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4608103)(4709054)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(49563074);SRVR:MWHPR01MB2478;
X-MS-TrafficTypeDiagnostic: MWHPR01MB2478:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;MWHPR01MB2478;20:ZRWVq0kOP8y7PKuXkm+bXz/K9rqFZxQdRmpMfNOuN/Y7YNe45KFvAIr9nvzSI1dT/otMi63mMg0F8Ojt9hZyGEXXnmWOxaZZ/fKzjo6etTnEIezA+TQ9iMCTdWSKcFRllyrOvGmSbp8N6tUYky/eHSFAxKj/0hrV5kMGQ/3ZlZf1n/IIdLC6gnzq3+Q7kAbQVriVkGfvlrzZwliHfnUc1y7wfbSAJ21/GRKM1V04DfOEhAHce3Y7SIn6OpYRqSq7HvxloZ0YETEuIKtoAjuXQPGv27qBT5Hx37Y7wllB7oIxHvMolPxWxsSt1hvIRUf2iXLQMIEru2Yc+2isQnBCLdPT+ID8AItjv35NPv0Eiail883Zw7HQhoBmLegJn/5kuL+BuLtyojEHL70mIfYCrIm1jjEWhS/BCEFI9PjaHaW7vTJJQcWD/cyhmwEN572/izD/CDF//Er8Kq0X+ue3YaY4T+zkj5i6NrEyZOyqRlXlQmd8JWVp9ZQTOj0CniODXsb1XpY68HHsfS3PSEfMENYuUndWN326u5Vy7XuSmO3rfMRgc5WZmU1V8NK+cDYZymSoA2yta4bGknbMCz6VkA6O94WMv9W2r8W/sjZqDaA=
X-Microsoft-Antispam-PRVS: <MWHPR01MB247888371A2DC55AC64CB920B5480@MWHPR01MB2478.prod.exchangelabs.com>
X-Forefront-PRVS: 09730BD177
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;MWHPR01MB2478;23:8xaG7ggLhxoHbLN5jcJIQ2TpCUlxSQ6p89rFxbJQw?=
 =?us-ascii?Q?2fUxUYOVAk4GY89k+jg1UA8M6z9QW+Xws8xnibAxXleIA70l16mWBTrc7azN?=
 =?us-ascii?Q?aYO+wNnO0kXNiHFERPi6ZG9HLlb6mwG/1F3+y8fVootMzPIExCsj3zm/7yec?=
 =?us-ascii?Q?gAmmeKq65EqjIMvMQWeN4l8ZlCV52nLTQfOLrF9ynT229LsrLoGKk3/J50Eh?=
 =?us-ascii?Q?qLdDIV35rlyRUPIPi8lX9Ti98sNaX50XfFTslZ4SR4JuUg6+NnhnV5D5VFL6?=
 =?us-ascii?Q?pgIdSe4kvfahlCGoIxS56WduxqkUFm9TZHu0NN3K3lDqrKGf8cIfwjSQ/V60?=
 =?us-ascii?Q?ryrz7CCQlUfbOVt0ME50r7XITyQb1TwNIdU1MPXcMx2BDvsuUeyE3T3wo3nK?=
 =?us-ascii?Q?Pnfcmv3OBGstmx3A+to00I5pCepShmBcDBWROTINK8TPbTXEKI/ZdvIpl43c?=
 =?us-ascii?Q?Alh6Dd6azgGwxxZsdv0Lec8rQ8sAWXTxyUrCt/dk15uPboqvTd8Iq97rUv9u?=
 =?us-ascii?Q?IkPITAMmDSjZ7Gl1eNlT1tJVKpNWTtQ8V0Pw7pcA/12ekR9bfVqtRBl8zKuw?=
 =?us-ascii?Q?W39UNwhfjZJuimhUkiaUoT65rY4aopg4b7pe+67RyO2Wh2CemkI/5Bc0IKF2?=
 =?us-ascii?Q?cs/exnEI776O7knQVRT9rfHRi6Cc3MJ2AR6X/FNvtkdrQuFifgXjoCOIZ4Ps?=
 =?us-ascii?Q?OiaUbeNPb3c0R8Rjs3yqfDSts2gpiOPR2o3P551GVi4CYzn6qhIYvVOHayWF?=
 =?us-ascii?Q?+CVmFW9G5eZzMXs7EDJlBi5facMLSzcxhXxwIi19h/zNsaEgoIzbDh6s8Y1L?=
 =?us-ascii?Q?tenBDV2byd+oCxNtmG84slIx0yDy3KY9VXOffs98ii5AvQGA9M3yiM7EDEPY?=
 =?us-ascii?Q?bWdf4b0V8Zl4q3P+x4AryLgYK1BtW1HXedGSrhSIqKJmIP1rKD8wSNnbAY7F?=
 =?us-ascii?Q?NTyVXRPnzvaF5XnHxBew3sGtAn8nhY66MRCpYoAo+4CYdNTLOytyWNjzg/uO?=
 =?us-ascii?Q?BcFQJ2V27ovga6UbufV8tI4jCqsbixo7CrX/0FKB0uIGpT/jVdETMCfKmlm6?=
 =?us-ascii?Q?yU8NPQB5uI7yfYVDnE10Bh+LXkQD38VdxiceRkVzFZ504VGkuIhvGiK5KApp?=
 =?us-ascii?Q?Wl3p1u+CoaRjHDdj6KEPzqI4L9+M7gfyXyp3GQVGdKYY4USeHMECw/oE7X8+?=
 =?us-ascii?Q?SUdOPZ2vJj8JnnG9nbJwPd4ztbevGOctgClM921Yx49POWeyeBMJQdEpaySZ?=
 =?us-ascii?Q?CzSCAQI7pEyUg3H/epTtwlX3XFeoGGxB533V5COuV12F24gimKMPWpZaI3MK?=
 =?us-ascii?Q?CIsV7kKZT3Ui+3ZZFOuQpHtldlh4mtD7n0TtpaknxVafCMW+bfRHOjMNSWrI?=
 =?us-ascii?Q?D9Z7g=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: shJq7tODfxHGSl/kTgQftendQ9gvXJryTGJKkeS8XartPJA1p0TfPpIwYrFXmOZ1OGICtPPl5Ripi2D+tFz1n3nptpLz/c5d9Vs+cTU+BOvX6yWmMAL2m3O6vNOJS7M//qVBb30zUojGDOEzBkQbY8Y62Pzz4qq5u3FZi+1AmhdzlMMOpj4ZoLEryc7YzFIWIdgCphYJG3mhf+PDSYKFiP7VuMqDx8hF+OXuFFiVCQd0OrJuL6ScJ7quFBz0WrMVTe2R0j940gjW2fZsgbhyzMgpy7ammaV8O4cDeNE10IduJaj5XNEV43mAZyVmHHk3RQWsCtkhuFnBXi6SoaR0jOgZYWrir53wgDwZqcM6l5d96bTYK01+baQwzgBFyK7YdQClE912Imgul5j8RD9BPSIEh5z9cx0u4USfrOlHJZU=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2019 00:22:11.1290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6877732e-d5cb-4e81-1d9f-08d6a5b79aeb
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB2478
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tag 924275 +pending
thanks

On Sun, Mar 10, 2019 at 09:29:04PM +0100, Sven Hartge wrote:
> 
> While I like the new fsck-via-LVM-snapshot feature, I think adding lvm2
> to Recommends is too agressive here.
> 
> On systems not using LVM this will needlessly pull in the whole LVM/DM
> machinery, including changes to the initramfs, as long as apt is in its
> default "install-recommends" configuration.
> 
> Only on systems where the system admin has changed the default to
> "no-install-recommends" nothing will happen.

Agreed; thanks for pointing this out!  I have the following patches
queued for the next release.

				- Ted


--n8g4imXOkfNTN/H1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-e2scrub-check-to-make-sure-lvm2-is-installed.patch"

From 04738f2ff3b8a2acaf2de09856e07601817350b5 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 10 Mar 2019 19:41:11 -0400
Subject: [PATCH 1/2] e2scrub: check to make sure lvm2 is installed

Not all systems will have the lvm2 package installed, so check for
that.  Pretty much all systems should have util-linux installed, but
check for that as well.

Of course, if lvm2 is installed we shouldn't find any LVM devices ---
but eventually the Demon Murphy will find a way to make it happen. :-)

Also, set the PATH so we don't have to worry about the script failing
due to /sbin not being in the path.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 scrub/e2scrub.in     | 12 ++++++++++++
 scrub/e2scrub_all.in | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
index e1965db4e..51a909373 100644
--- a/scrub/e2scrub.in
+++ b/scrub/e2scrub.in
@@ -23,6 +23,8 @@
 # check filesystems in VGs that have at least 256MB (or so) of
 # free space.
 
+PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
+
 snap_size_mb=256
 fstrim=0
 reap=0
@@ -82,6 +84,16 @@ if [ -z "${arg}" ]; then
 	exitcode 1
 fi
 
+if ! type lsblk >& /dev/null ; then
+    echo "e2scrub: can't find lsblk --- is util-linux installed?"
+    exitcode 1
+fi
+
+if ! type lvcreate >& /dev/null ; then
+    echo "e2scrub: can't find lvcreate --- is lvm2 installed?"
+    exitcode 1
+fi
+
 # Find the device for a given mountpoint
 dev_from_mount() {
 	local mountpt="$(realpath "$1")"
diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index 23d122d25..d725a7f2e 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -18,6 +18,8 @@
 #  along with this program; if not, write the Free Software Foundation,
 #  Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
 
+PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
+
 scrub_all=0
 conffile="@root_sysconfdir@/e2scrub.conf"
 
@@ -68,6 +70,20 @@ while getopts "ArV" opt; do
 done
 shift "$((OPTIND - 1))"
 
+# If some prerequisite packages are not installed, exit with a code
+# indicating success to avoid spamming the sysadmin with fail messages
+# when e2scrub_all is run out of cron or a systemd timer.
+
+if ! type lsblk >& /dev/null ; then
+    echo "e2scrub_all: can't find lsblk --- is util-linux installed?"
+    exitcode 0
+fi
+
+if ! type lvcreate >& /dev/null ; then
+    echo "e2scrub_all: can't find lvcreate --- is lvm2 installed?"
+    exitcode 0
+fi
+
 # Find scrub targets, make sure we only do this once.
 ls_scrub_targets() {
 	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
-- 
2.19.1


--n8g4imXOkfNTN/H1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-debian-drop-lvm2-from-the-recommends-line.patch"

From 212ba2a8a81001bce21cce314f9bc2967f2df7c7 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 10 Mar 2019 20:01:58 -0400
Subject: [PATCH 2/2] debian: drop lvm2 from the recommends line

If the user doesn't intend to use lvm2, and it's not installed,
installing e2fsprogs shouldn't drag it (and all of its dependencies)
into the system.

Addresses-Debian-Bug: 924275

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 1bb8adb15..e454687f9 100644
--- a/debian/control
+++ b/debian/control
@@ -191,7 +191,7 @@ XB-Important: yes
 Pre-Depends: ${shlibs:Depends}, ${misc:Depends}, libblkid1, libuuid1
 Multi-Arch: foreign
 Suggests: gpart, parted, fuse2fs, e2fsck-static
-Recommends: e2fsprogs-l10n, lvm2
+Recommends: e2fsprogs-l10n
 Architecture: any
 Description: ext2/ext3/ext4 file system utilities
  The ext2, ext3 and ext4 file systems are successors of the original ext
-- 
2.19.1


--n8g4imXOkfNTN/H1--
