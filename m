From: Jean noel Cordenner <jean-noel.cordenner@bull.net>
Subject: [patch 0/2] i_version update
Date: Fri, 25 May 2007 18:25:31 +0200
Message-ID: <46570DFB.3080101@bull.net>
Reply-To: jean-noel.cordenner@bull.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This is an update of the i_version patch.
The i_version field is a 64bit counter that is set on every inode
creation and that is incremented every time the inode data is modified
(similarly to the "ctime" time-stamp).
The aim is to fulfill a NFSv4 requirement for rfc3530:
"5.5.  Mandatory Attributes - Definitions
Name		#	DataType   Access   Description
___________________________________________________________________
change		3	uint64       READ     A value created by the
		server that the client can use to determine if file
		data, directory contents or attributes of the object
		have been modified.  The servermay return the object's
		time_metadata attribute for this attribute's value but
		only if the filesystem object can not be updated more
		frequently than the resolution of time_metadata.
"

The patch set is divided into 2parts, the vfs layer and a ext4 specific 
code.

Any comments welcome.

Cheers,
Jean noel
