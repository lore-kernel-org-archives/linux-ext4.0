From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: Re: [RFC] [patch 0/3] i_version update for ext4
Date: Wed, 24 Jan 2007 15:12:49 +0100
Message-ID: <45B76961.7030509@bull.net>
References: <45B644AA.1070409@bull.net>
	<20070123184611.GF5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <20070123184611.GF5236@schatzie.adilger.int>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger a =E9crit :
> On Jan 23, 2007  18:23 +0100, Cordenner jean noel wrote:
>> I've updated what was previously the change attribute patch for ext4 =

>> initially posted by Alexandre Ratchov. The previous patch was =

>> introducing a change_attribute field, now it uses the i_version field of =

>> the inode.
>>
>> The i_version field is a counter that is set on every inode creation and =

>> that is incremented every time the inode data is modified (similarly to =

>> the "ctime" time-stamp).
>> The aim is to fulfill NFSv4 requirements for rfc3530.
>> For the moent, the counter is only a 32bit value but it is planned to be =

>> 64bit as required.
>>
>> The patch is divided into 3 parts, the vfs layer, the ext4 specific code =

>> and an user part to check i_version changes via stat.
> =

> Have you had a chance to look at the performance impact of this change
> (possible with oprofile)?  Always marking the inodes dirty for ext3
> may have some noticable overhead.
>

I did some tests using fileop with the previous version of the patch =

which was very similar. I was surprised that there was no noticable =

overhead:
  http://www.bullopensource.org/ext4/change_attribute/index.html

I will use oprofile to check it again.
