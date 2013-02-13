From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 09:17:28 +0100
Message-ID: <511B4C18.8030300@itwm.fraunhofer.de>
References: <20130212202841.GC10267@fieldses.org> <511AAC89.3060409@itwm.fraunhofer.de> <20130212210054.GF10267@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	"Theodore Ts'o" <tytso@mit.edu>, gluster-devel@nongnu.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:38892 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3BMIRg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2013 03:17:36 -0500
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r1D8HVRZ016766
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2013 09:17:32 +0100
In-Reply-To: <20130212210054.GF10267@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/12/2013 10:00 PM, J. Bruce Fields wrote:
> On Tue, Feb 12, 2013 at 09:56:41PM +0100, Bernd Schubert wrote:
>> On 02/12/2013 09:28 PM, J. Bruce Fields wrote:
>>> 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
>>> and previous patches solved problems with hash collisions in large
>>> directories by using 64- instead of 32- bit directory hashes in some
>>> cases.  But it caused problems for users who assume directory offsets
>>> are "small".  Two cases we've run across:
>>>
>>> 	- older NFS clients: 64-bit cookies cause applications on many
>>> 	  older clients to fail.
>>> 	- gluster: gluster assumed that it could take the top bits of
>>> 	  the offset for its own use.
>>>
>>> In both cases we could argue we're in the right: the nfs protocol
>>> defines cookies to be 64 bits, so clients should be prepared to handle
>>> them (remapping to smaller integers if necessary to placate applications
>>> using older system interfaces).  And gluster was incorrect to assume
>>> that the "offset" was really an "offset" as opposed to just an opaque
>>> value.
>>>
>>> But in practice things that worked fine for a long time break on a
>>> kernel upgrade.
>>>
>>> So at a minimum I think we owe people a workaround, and turning off
>>> dir_index may not be practical for everyone.
>>>
>>> A "no_64bit_cookies" export option would provide a workaround for NFS
>>> servers with older NFS clients, but not for applications like gluster.
>>>
>>> For that reason I'd rather have a way to turn this off on a given ext4
>>> filesystem.  Is that practical?
>>
>> I think Ted needs to answer if he would accept another mount option. But
>> before we are going this way, what is gluster doing if there are hash
>> collions?
>
> They probably just haven't tested NFS with large enough directories.

Is it only related to NFS or generic readdir over gluster?

> The birthday paradox says you'd need about 2^16 entries to have a 50-50
> chance of hitting the problem.

We are frequently running into it with 50000 files per directory.

>
> I don't know enough about ext4 directory performance.  But unfortunately
> I suspect there's a range of directory sizes that are too small to have
> a significant chance of having directory collisions, but still large
> enough to need dir_index?

Here is a link to the initial benchmark:
http://search.luky.org/linux-kernel.2001/msg00117.html


Cheers,
Bernd
