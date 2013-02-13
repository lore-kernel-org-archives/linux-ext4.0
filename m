From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [Gluster-devel] regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 16:40:35 +0100
Message-ID: <511BB3F3.7010608@itwm.fraunhofer.de>
References: <20130212202841.GC10267@fieldses.org> <511AAC89.3060409@itwm.fraunhofer.de> <20130212210054.GF10267@fieldses.org> <20130213133133.GB23233@ndevos-laptop.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields@fieldses.org>, sandeen@redhat.com,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	gluster-devel@nongnu.org
To: Niels de Vos <ndevos@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:38875 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab3BMPkm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2013 10:40:42 -0500
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r1DFedff007519
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2013 16:40:39 +0100
In-Reply-To: <20130213133133.GB23233@ndevos-laptop.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/13/2013 02:31 PM, Niels de Vos wrote:
> On Tue, Feb 12, 2013 at 04:00:54PM -0500, J. Bruce Fields wrote:
>> On Tue, Feb 12, 2013 at 09:56:41PM +0100, Bernd Schubert wrote:
>>> On 02/12/2013 09:28 PM, J. Bruce Fields wrote:
>>>> 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
>>>> and previous patches solved problems with hash collisions in large
>>>> directories by using 64- instead of 32- bit directory hashes in some
>>>> cases.  But it caused problems for users who assume directory offsets
>>>> are "small".  Two cases we've run across:
>>>>
>>>> 	- older NFS clients: 64-bit cookies cause applications on many
>>>> 	  older clients to fail.
>>>> 	- gluster: gluster assumed that it could take the top bits of
>>>> 	  the offset for its own use.
>>>>
>>>> In both cases we could argue we're in the right: the nfs protocol
>>>> defines cookies to be 64 bits, so clients should be prepared to handle
>>>> them (remapping to smaller integers if necessary to placate applications
>>>> using older system interfaces).  And gluster was incorrect to assume
>>>> that the "offset" was really an "offset" as opposed to just an opaque
>>>> value.
>>>>
>>>> But in practice things that worked fine for a long time break on a
>>>> kernel upgrade.
>>>>
>>>> So at a minimum I think we owe people a workaround, and turning off
>>>> dir_index may not be practical for everyone.
>>>>
>>>> A "no_64bit_cookies" export option would provide a workaround for NFS
>>>> servers with older NFS clients, but not for applications like gluster.
>>>>
>>>> For that reason I'd rather have a way to turn this off on a given ext4
>>>> filesystem.  Is that practical?
>>>
>>> I think Ted needs to answer if he would accept another mount option. But
>>> before we are going this way, what is gluster doing if there are hash
>>> collions?
>>
>> They probably just haven't tested NFS with large enough directories.
>> The birthday paradox says you'd need about 2^16 entries to have a 50-50
>> chance of hitting the problem.
>
> The Gluster NFS-server gets into an infinite loop:
> - https://bugzilla.redhat.com/show_bug.cgi?id=838784

Hmm, this bugzilla is not entirely what I meant, as it refers to 64-bit 
hashes.
My question actually was, what is gluster going to do if there is a 
32-bit hash collision and ext4 seeks back to a random entry?
That might end in an endless loop, but it also simply might list entries 
multiple times on readdir().
Of course, something that only happens rarely is better than something 
that happens all the time, but it still would be better to properly fix 
it, wouldn't it?

> The general advise (even before this Bug) is that XFS should be used,
> which is not affected with this problem (yet?).

Hmm, well, always depends on the workload.


Cheers,
Bernd
