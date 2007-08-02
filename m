From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] e2fsprogs: Add undo I/O manager
Date: Fri, 03 Aug 2007 00:02:32 +0530
Message-ID: <46B22340.5020709@linux.vnet.ibm.com>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com> <20070801225247.GC5692@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53667 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525AbXHBSeC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 14:34:02 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l72IappC193722
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 04:36:51 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l72IaHrG158254
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 04:36:17 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l72IWiZJ022491
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 04:32:44 +1000
In-Reply-To: <20070801225247.GC5692@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Aug 01, 2007  21:04 +0530, Aneesh Kumar K.V wrote:
>> +static errcode_t write_file_system_identity(io_channel undo_channel,
>> +							TDB_CONTEXT *tdb)
>> +{
>> +	/* Write to tdb file in the file system byte order */
>> +	tdb_key.dptr = "filesystem MTIME";
>> +	tdb_key.dsize = sizeof("filesystem MTIME");
>> +	tdb_data.dptr = (unsigned char *) &(super.s_mtime);
>> +	tdb_data.dsize = sizeof(super.s_mtime);
>> +
>> +	tdb_key.dptr = "filesystem UUID";
>> +	tdb_key.dsize = sizeof("filesystem UUID");
>> +	tdb_data.dptr = (unsigned char *)&(super.s_uuid);
>> +	tdb_data.dsize = sizeof(super.s_uuid);
> 
> Is this the mtime and UUID of the new filesystem or the old one?  It
> should be the UUID and mtime of the new filesystem, so that the
> undo file can be verified against the current superblock.  This poses
> a bit of a problem, because that information isn't saved until after
> the mke2fs run is finished.
> 
> One possibility is to overwrite this information at the end of mke2fs
> after the new UUID and mtime are written?
> 

This can be done by writing the file system identity during the the io_channel_close.
How about this patch on top of the last series. I will merge this into the patcheset

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 30e2514..a80bafc 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -159,8 +159,8 @@ static errcode_t write_file_system_identity(io_channel undo_channel,
 	/* Also store the block size */
 	tdb_key.dptr = "filesystem BLKSIZE";
 	tdb_key.dsize = sizeof("filesystem BLKSIZE");
-	tdb_data.dptr = (unsigned char *)&(undo_channel->block_size);
-	tdb_data.dsize = sizeof(undo_channel->block_size);
+	tdb_data.dptr = (unsigned char *)&(tdb_data_size);
+	tdb_data.dsize = sizeof(tdb_data_size);
 
 	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
 	if (retval == -1) {
@@ -199,13 +199,6 @@ static errcode_t undo_write_tdb(io_channel channel,
 	 */
 	if (!tdb_data_size) {
 		tdb_data_size = channel->block_size;
-
-		/*
-		 * First write. Write the file system identity
-		 */
-		retval = write_file_system_identity(channel, data->tdb);
-		if (retval)
-			return retval;
 	}
 
 	if (count == 1)
@@ -405,6 +398,11 @@ static errcode_t undo_close(io_channel channel)
 	if (--channel->refcount > 0)
 		return 0;
 
+	/* Before closing Write the file system identity */
+	retval = write_file_system_identity(channel, data->tdb);
+	if (retval)
+		return retval;
+
 	if (data->real)
 		retval = io_channel_close(data->real);
 
