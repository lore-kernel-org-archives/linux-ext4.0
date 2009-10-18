From: Viji V Nair <viji@fedoraproject.org>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 18:21:53 +0530
Message-ID: <84c89ac10910180551j123e94a7ud5dce240619ab99@mail.gmail.com>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	<4AD9D599.3000306@redhat.com>
	<84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	<20091017222619.GA10074@mit.edu>
	<84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
	<1255865110.27380.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	ext3-users@redhat.com
To: Jon Burgess <jburgess777@googlemail.com>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <1255865110.27380.52.camel@localhost.localdomain>
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

On Sun, Oct 18, 2009 at 4:55 PM, Jon Burgess <jburgess777@googlemail.com>=
 wrote:
> On Sun, 2009-10-18 at 15:01 +0530, Viji V Nair wrote:
>> The application which we are using are modified versions of mapnik and
>> tilecache, these are single threaded so we are running 4 process at a
>> time.
>
> If your tiles use the OpenStreetMap / Google style 900913 projection
> then you could consider using mod_tile[1]. This renders and stores each
> block of 8 x 8 PNG map tiles inside a single file on the disk. This
> makes the storage and access much more efficient. It cuts down the
> number of files on the disk by 64 and allows nearby tiles to be read
> from a single file.
>
> =A0 =A0 =A0 =A0Jon
>
> 1: http://wiki.openstreetmap.org/wiki/Mod_tile

we are using our own data set, not google map or openstreet map. Since
we are using mapnik layer I will surely give a try with this.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
