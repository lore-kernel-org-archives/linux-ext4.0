From: armangau_philippe@emc.com
Subject: RE: Ext3 behavior on power failure
Date: Wed, 28 Mar 2007 10:17:33 -0400
Message-ID: <A74E8B4A356D8143B79BBEB839421F300415A86B@CORPUSMX20B.corp.emc.com>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com>
	<4603B03E.7080302@emc.com>
	<20070328124015.GG14935@atrey.karlin.mff.cuni.cz>
	<alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org, ric@echidna.lss.emc.com,
	ext3-users@redhat.com, csar@stanford.edu
To: <jakj@j-a-k-j.com>, <jack@suse.cz>
Return-path: <ext3-users-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

In my case the disk cache is not a  problem - We use an emc disk array
the write cache is protected -=20
Once the data has made over the disk array we can assume it is safe -=20
Thx=20
Philippe =20

-----Original Message-----
From: John Anthony Kazos Jr. [mailto:jakj@j-a-k-j.com]=20
Sent: Wednesday, March 28, 2007 9:17 AM
To: Jan Kara
Cc: wheeler, richard; armangau, philippe; ext3-users@redhat.com;
linux-ext4@vger.kernel.org; csar@stanford.edu
Subject: Re: Ext3 behavior on power failure

>  If you fsync() your data, you are guaranteed that also your data are
> safely on disk when fsync returns. So what is the question here?

Pardon a newbie's intrusion, but I do know this isn't true. There is a=20
window of possible loss because of the multitude of layers of caching,=20
especially within the drive itself. Unless there is a
super_duper_fsync()=20
that is able to actually poll the hardware and get a confirmation that
the=20
internal buffers are purged?
