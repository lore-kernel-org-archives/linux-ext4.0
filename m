From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Undeletion utililty for ext3/4
Date: Fri, 1 May 2009 14:09:21 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0905011406450.6162@bogon.housecafe.de>
References: <938911.2430.qm@web43504.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, ext-users <Ext3-users@redhat.com>
To: Number9652 <number9652@yahoo.com>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <938911.2430.qm@web43504.mail.sp1.yahoo.com>
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

On Thu, 30 Apr 2009, Number9652 wrote:
> I have recently released a project on sourceforge 
> ( http://extundelete.sourceforge.net ) that can undelete a file from an 
> ext3 or ext4 partition.  It uses code from ext3grep to parse 
> command-line options, and uses libext2fs to read the partitions.
> Instead of reading the entire partition, as ext3grep does, it reads 
> only the journal file and is able to restore a deleted file from the 
> information there and in (possibly deleted) directory blocks.  I hope it 
> is of some use.

Thanks - I've added this to the collection of ext2/3 undeletion tools in 
the wiki: http://ext4.wiki.kernel.org/index.php/Undeletion

Christian.
-- 
Bruce Schneier once broke AES using nothing but six feet of rusty barbed wire,
a toothpick, and the front axle from a 1962 Ford Falcon.
